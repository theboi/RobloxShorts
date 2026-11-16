--!strict
-- Pure timeline math: shared by Studio playback, offline tests, and subtitle export.
local Timeline = {}
export type Shot = { id: string, duration: number, [string]: any }
export type Film = { shots: { Shot }, starts: { number }, duration: number }

local function finite(value: number): boolean
	return value == value and math.abs(value) < math.huge
end

function Timeline.compile(shots: { Shot }): Film
	assert(#shots > 0, "Film needs at least one shot")
	local starts, seen, duration = {}, {}, 0
	for _, shot in shots do
		assert(type(shot.id) == "string" and #shot.id > 0, "Shot needs an id")
		assert(not seen[shot.id], "Duplicate shot id: " .. shot.id)
		assert(
			type(shot.duration) == "number" and finite(shot.duration) and shot.duration > 0,
			"Invalid shot duration: " .. shot.id
		)
		seen[shot.id] = true
		table.insert(starts, duration)
		duration += shot.duration
	end
	return { shots = shots, starts = starts, duration = duration }
end

function Timeline.sample(film: Film, seconds: number)
	assert(finite(seconds), "Seek time must be finite")
	local t = math.clamp(seconds, 0, film.duration)
	local index = #film.shots
	for i = 1, #film.shots - 1 do
		if t < film.starts[i + 1] then
			index = i
			break
		end
	end
	local shot = film.shots[index]
	local elapsed = t - film.starts[index]
	return { shot = shot, index = index, elapsed = elapsed, alpha = elapsed / shot.duration, time = t }
end

function Timeline.lerp(a: number, b: number, alpha: number): number
	return a + (b - a) * math.clamp(alpha, 0, 1)
end

return Timeline
