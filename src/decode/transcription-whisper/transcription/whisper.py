#!/usr/bin/env python3
import argparse
from faster_whisper import WhisperModel

if __name__ == "__main__":
  argparser = argparse.ArgumentParser(description='Semantika Ausis is client')
  # Optional positional argument
  argparser.add_argument('--input', '-i', type=str, 
                      help='An required path to audio signal')

  args = argparser.parse_args()
  input_path = args.input #"audio-files/test.wav"
  #model = WhisperModel("isLucid/faster-whisper-large-v2-20240901", device="cuda")
  model = WhisperModel("isLucid/whisper-large-v3-turbo", download_root="/models/hub/", device="cuda")
  segments, info = model.transcribe(input_path, word_timestamps=True, language="lt")
  #print("\ninfo:\n", info)
  #print("\nsegments:\n", segments)
  
  print("# 1 S0000")

  for segment in segments:
      #print("[%.2fs -> %.2fs] %s" % (segment.start, segment.end, segment.text))
      for word in segment.words:
          #print("\t[%.2fs -> %.2fs] %s" % (word.start, word.end, word.word))
          word_txt=word.word.rstrip(".").lstrip(" ")
          print("1 %.2f %.2f %s" % (word.start, word.end, word_txt))
