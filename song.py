
from pytubefix import YouTube
import os

link = input("Ingrese el link de YouTube de la canción que desea descargar: ")
link = str(link)
play_list = [link]

downloaded_count = 0

def download_from_yt(url, total):
    global downloaded_count
    try:
        yt = YouTube(url)
        video = yt.streams.filter(only_audio=True).first()
        destination = './mp3_files'
        out_file = video.download(output_path=destination)
        base, ext = os.path.splitext(out_file)
        new_file = base + '.mp3'
        os.rename(out_file, new_file)
    except FileExistsError:
        downloaded_count += 1
        print("Archivo .mp3 ya existente", yt.title)
    except:
        print("Error en la descarga")
    else:
        downloaded_count += 1
        print(yt.title, "Descargado exitosamente")

for song in play_list:
    download_from_yt(song, len(play_list))