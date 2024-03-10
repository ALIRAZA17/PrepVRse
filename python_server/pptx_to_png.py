import os
import comtypes.client

def pptx_to_pngs(pptx_path, output_dir):
    if not os.path.exists(output_dir):
        os.makedirs(output_dir)

    powerpoint = comtypes.client.CreateObject("Powerpoint.Application")
    powerpoint.Visible = 1

    ppt = powerpoint.Presentations.Open(pptx_path)

    for i, slide in enumerate(ppt.Slides):
        slide.Export(os.path.join(output_dir, f"slide_{i+1}.png"), "PNG")

    ppt.Close()
    powerpoint.Quit()
