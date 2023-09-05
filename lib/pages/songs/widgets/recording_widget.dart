import 'dart:ui';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_sound_lite/flutter_sound.dart';
import 'package:flutter_sound_lite/public/flutter_sound_recorder.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:oneui/bloc/auth_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:uuid/uuid.dart';

import '../../../models/song.dart';

class RecordingWidget extends HookConsumerWidget {
  late FlutterSoundRecorder audioRecord;
  RecordingWidget({super.key});

  void saveDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text("Save your affirmations"),
            content: const Text("Do you want to save your affirmations?"),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text("No")),
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text("Yes")),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isRecording = useState(false);
    final animationController = useAnimationController();
    final upLoadTask = useState<UploadTask?>(null);
    final isTransferring = useState(false);
    final dialogEditor = useTextEditingController();

    useEffect(() {
      audioRecord = FlutterSoundRecorder();

      return audioRecord.closeAudioSession;
    }, []);

    final onRecord = useCallback(() async {
      await audioRecord.openAudioSession();
      var status = await Permission.microphone.request();
      if (status != PermissionStatus.granted) {
        throw RecordingPermissionException('Microphone permission not granted');
      }
      await audioRecord.startRecorder(
        toFile: "audio.mp4",
      );
    }, []);

    final onStopRecord = useCallback((String filename) async {
      final db = ref.read(firebaseDBProvider);
      final newUid = Uuid().v4();
      isTransferring.value = true;

      //print("saved path is $path");
      upLoadTask.value = await audioRecord.stopRecorder().then(
          (path) => db.uploadData(path: path!, refPath: "songs/$newUid.mp4"));
      final currentUser = await ref.read(firebaseDBProvider).getCurrentUser();
      // on upload complete
      upLoadTask.value!.whenComplete(() async {
        final url = await upLoadTask.value!.snapshot.ref.getDownloadURL();
        isTransferring.value = false;
        upLoadTask.value = null;
        Song newSong = Song(
            tab: 'affirmations',
            title: filename,
            url: url,
            user: currentUser,
            artist: currentUser.name,
            album: "Life Changing Affirmations",
            albumArt:
                "https://dailyburn.com/life/wp-content/uploads/2017/05/positive-affirmations-cover.jpg");
        db.addSong(newSong).then((value) => Navigator.pop(context));
      });
    }, []);

    useEffect(() {
      if (isRecording.value) {
        animationController.repeat(reverse: true);
        onRecord();
      } else {
        animationController.stop();
      }
      return null;
    }, [isRecording.value]);

    print("building");
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        children: [
          // Record your affirmations

          // red button

          // text field
          Text(
            "Record your affirmations ${isRecording.value}",
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(
            height: 12.0,
          ),
          Center(
              child: IconButton(
            icon: CircleAvatar(
                radius: 30.0,
                child: Icon(
                  Icons.mic,
                  color: Colors.red.shade400,
                  size: 50.0,
                )),
            onPressed: () {
              isRecording.value = !isRecording.value;
              // if new value is stopped
              if (isRecording.value == false) {
                print("on stopping");
                // show modal
                Future data = showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: const Text("Save your affirmations"),
                        content:  TextField(
                          controller: dialogEditor,
                          decoration: const InputDecoration(
                              hintText: "Enter your affirmations")),
                        actions: [
                          TextButton(
                              onPressed: () {
                                Navigator.pop(context, {
                                  "save": false,
                                  "text": dialogEditor.text
                                });
                              },
                              child: const Text(
                                "No",
                              )),
                          TextButton(
                              onPressed: () {
                                Navigator.pop(context, {
                                  "save": true,
                                  "text": dialogEditor.text
                                });
                              },
                              child: const Text("Yes")),
                        ],
                      );
                    });

                data.then((value) {
                  if(value["save"] == true){
                    // save the affirmations
                    onStopRecord(value["text"]);

                  }
                  else{
                    Navigator.pop(context);
                  }
                });
              }
            },
          )
                  .animate(
                    controller: animationController,
                  )
                  .scaleXY(end: 1.1, curve: Curves.easeInOutCubic)
                  .tint(
                      end: isRecording.value ? 0.6 : 0,
                      curve: Curves.easeInOutCubic)),

          // progressbar
          const SizedBox(
            height: 20.0,
          ),
          StreamBuilder(
            stream: audioRecord.onProgress,
            builder: (context, snapshot) {
              if(snapshot.hasError){
                return Text("Error: ${snapshot.error}");
              }
              if (snapshot.hasData) {
                final data = snapshot.data as RecordingDisposition;
                return Text(
                  "State: ${data.duration.toString().substring(0, 7)}",
                  style: Theme.of(context).textTheme.titleMedium!.copyWith(
                      color: Colors.red.shade400,
                      fontWeight: FontWeight.bold
                  )
                  
                );
              }
              return const SizedBox.shrink();
            },
            
          ),
          const SizedBox(
            height: 20.0,
          ),
          if (upLoadTask.value != null)
            progressWidget(upLoadTask.value, isTransferring),
        ],
      ),
    );
  }

  Widget progressWidget(uploadTask, isTransferring) {
    return StreamBuilder<TaskSnapshot>(
        stream: uploadTask.snapshotEvents,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final snap = snapshot.data!;
            final progress = snap.bytesTransferred / snap.totalBytes;
            return LinearProgressIndicator(
              value: progress,
              backgroundColor: Colors.grey,
              valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
            );
          }
          return const SizedBox.shrink();
        });
  }
}
