import librosa as librosa
import matplotlib.pyplot as plt
import numpy as np
import song as sg
from pydub import AudioSegment
from librosa.display import specshow

sg
audio =sg.ruta
y, sr = librosa.load(audio)
S = np.abs(librosa.stft(y))
freqs = librosa.fft_frequencies(sr=sr)
idx = np.argmax(S, axis=0)
dominante_freqs = freqs[idx]

print(dominante_freqs)
