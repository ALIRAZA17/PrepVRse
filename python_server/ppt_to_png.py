import os
import comtypes.client

def pptx_to_pngs(pptx_path, output_dir):
    # Ensure output directory exists
    if not os.path.exists(output_dir):
        os.makedirs(output_dir)

    # Initialize PowerPoint
    powerpoint = comtypes.client.CreateObject("Powerpoint.Application")
    powerpoint.Visible = 1

    # Open the presentation
    ppt = powerpoint.Presentations.Open(pptx_path)

    # Go through each slide and export it as PNG
    for i, slide in enumerate(ppt.Slides):
        slide.Export(os.path.join(output_dir, f"slide_{i+1}.png"), "PNG")

    # Close the presentation and PowerPoint
    ppt.Close()
    powerpoint.Quit()

pptx_path = "D:\projects\FYP\prepvrse\python_server\Lec.pptx"
output_dir = "D:\projects\FYP\prepvrse\python_server"

pptx_to_pngs(pptx_path, output_dir)
