from pytubefix import YouTube
import librosa
import pyloudnorm as pyln
import os



def download_from_yt(url):
    try:
        use_po_token=True 
        yt = YouTube(url)
        video = yt.streams.filter(only_audio=True).first()
        destination = 'songs'
        out_file = video.download(output_path=destination)
        base, ext = os.path.splitext(out_file)
        new_file = base + '.mp3'
        os.rename(out_file, new_file)
        print(f"{yt.title} descargado exitosamente en {new_file}")
        return new_file
    except Exception as e:
        print("Error en la descarga:", e)
        return None


link = input("Ingrese el link de YouTube de la canción que desea descargar: ")
ruta_cancion = download_from_yt(link)
if not ruta_cancion:
    print("No se pudo descargar la canción.")
    
cancion = ruta_cancion
try:
    y, sr = librosa.load(cancion)

    # Análisis de rango dinámico
    peak = max(y)
    range = librosa.feature.rms(y=y)[0].mean()
    dynamic_range = peak - range
    print(f"Rango dinámico: {dynamic_range}")
    
    # Volumen promedio
    meter = pyln.Meter(sr)
    vol = meter.integrated_loudness(y)
    print(f"Volumen promedio: {vol}")

    # Duración
    duracion = librosa.get_duration(y=y, sr=sr)
    print(f"Duración de la canción: {duracion:.2f} segundos")
     
except Exception as e:
    print(f"Error al analizar la cancion: {e}")
