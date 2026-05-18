# import os
# import re

# base_folder = r"C:\Users\think pad T480\OneDrive\Desktop\Kasmiri_English\train"

# for speaker_folder in os.listdir(base_folder):
#     speaker_path = os.path.join(base_folder, speaker_folder)
    
#     # Skip if not a folder
#     if not os.path.isdir(speaker_path):
#         continue
    
#     waveforms_path = os.path.join(speaker_path, "transcriptions")
    
#     if not os.path.exists(waveforms_path):
#         continue
    
#     print(f"\nProcessing {speaker_folder}...")
    
#     for filename in os.listdir(waveforms_path):
#         if filename.endswith(".wav") or filename.endswith(".txt"):
            
#             # Match pattern: Speaker 1 F_sentence01.wav
#             match = re.match(r"Speaker (\d+) .*_sentence(\d+)\.(wav|txt)", filename)
            
#             if match:
#                 spkr_num = match.group(1)
#                 sentence_num = int(match.group(2))
#                 ext = match.group(3)
                
#                 new_name = f"spkr{spkr_num}_{sentence_num}.{ext}"
                
#                 old_path = os.path.join(waveforms_path, filename)
#                 new_path = os.path.join(waveforms_path, new_name)
                
#                 os.rename(old_path, new_path)
#                 print(f"{filename} → {new_name}")

# print("\n✅ All speakers renamed successfully!")


import os
import re

base_folder = r"C:\Users\think pad T480\OneDrive\Desktop\Kasmiri_English\train"

for speaker_folder in os.listdir(base_folder):
    speaker_path = os.path.join(base_folder, speaker_folder)

    if not os.path.isdir(speaker_path):
        continue

    print(f"\n🔄 Processing {speaker_folder}...")

    transcriptions_path = os.path.join(speaker_path, "transcriptions")

    if os.path.exists(transcriptions_path):
        for filename in os.listdir(transcriptions_path):

            if filename.endswith(".txt"):
                match = re.match(r"spkr(\d+)_(\d+)\.txt", filename)

                if match:
                    spkr_num = match.group(1)
                    sentence_num = int(match.group(2))

                    new_name = f"spkr{spkr_num}_{sentence_num}.lab"

                    old_path = os.path.join(transcriptions_path, filename)
                    new_path = os.path.join(transcriptions_path, new_name)

                    os.rename(old_path, new_path)
                    print(f"{filename} → {new_name}")

print("\n✅ All speakers processed (wav renamed + txt converted to .lab)!")