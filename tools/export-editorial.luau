--!strict
local fs = require("@lune/fs")
local serde = require("@lune/serde")
local Timeline = require("../src/shared/Timeline")
fs.writeDir("build/editorial")
local function timestamp(seconds)
	local ms = math.floor(seconds * 1000 + 0.5)
	return string.format(
		"%02d:%02d:%02d,%03d",
		math.floor(ms / 3600000),
		math.floor(ms / 60000) % 60,
		math.floor(ms / 1000) % 60,
		ms % 1000
	)
end
for _, film in { require("../src/films/Power"), require("../src/films/Gate") } do
	local timeline = Timeline.compile(film.shots)
	local subtitles, records = {}, {}
	for i, shot in film.shots do
		table.insert(
			subtitles,
			string.format(
				"%d\n%s --> %s\n%s\n",
				i,
				timestamp(timeline.starts[i]),
				timestamp(timeline.starts[i] + shot.duration),
				shot.text
			)
		)
		table.insert(
			records,
			{
				id = shot.id,
				start = timeline.starts[i],
				duration = shot.duration,
				text = shot.text,
				cue = shot.cue,
			}
		)
	end
	fs.writeFile(`build/editorial/{film.id}.srt`, table.concat(subtitles, "\n"))
	fs.writeFile(
		`build/editorial/{film.id}.json`,
		serde.encode("json", { title = film.title, duration = timeline.duration, shots = records }, true)
	)
	print(`Exported {film.id}: {timeline.duration}s editorial timeline`)
end
