import glob
import json
import os

print(os.getcwd())

for file in glob.glob('API/*.json'):
    with open(file) as f:
        data = f.read()
        data = data.replace('}{', '},{')
        json_objects = json.loads(f'[{data}]')
        if os.path.exists('API/final.json'):
            with open('API/final.json', 'r') as f:
                try:
                    final_data = json.load(f)
                except json.JSONDecodeError:
                    final_data = []
                final_data.extend(json_objects)
            with open('API/final.json', 'w') as f:
                json.dump(final_data, f, indent=4)
        else:    
            with open('API/final.json', 'w') as f:
                json.dump(json_objects, f, indent=4)
                                            