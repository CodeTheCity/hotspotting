import shlex, json

points = []

with open('ArchitecturePics.txt') as fin:
    for line in fin:
        points.append(shlex.split(line))

obj = {'points': [{'lat':p[-3], 'lng':p[-2]} for p in points[1:]]}

with open('Architecture.json', 'w') as fout:
    json.dump(obj, fout)
