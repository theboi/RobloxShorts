--!strict
-- Catches shot-boundary errors, frame-rate-dependent seeking, and invalid edits.
local Timeline = require("../src/shared/Timeline")

local fixture = {
	{ id = "one", duration = 2, actors = { Eli = { from = { 0, 0, 0 }, to = { 10, 0, 0 } } } },
	{ id = "two", duration = 3, actors = {} },
}
local film = Timeline.compile(fixture)
assert(film.duration == 5, "duration must sum shots")
local middle = Timeline.sample(film, 1)
assert(middle.shot.id == "one" and middle.alpha == 0.5, "midpoint interpolation")
assert(Timeline.sample(film, 2).shot.id == "two", "boundary must cut to incoming shot")
assert(Timeline.sample(film, -5).alpha == 0, "negative seeks clamp")
assert(Timeline.sample(film, 9).alpha == 1, "end seeks clamp")
assert(Timeline.sample(film, 1).alpha == middle.alpha, "backward seeks cannot retain state")
assert(Timeline.lerp(2, 10, 0.25) == 4, "linear interpolation")
for _, bad in
	{
		{},
		{ { id = "bad", duration = 0 } },
		{ { id = "bad", duration = -1 } },
		{ { id = "bad", duration = 0 / 0 } },
		{ { id = "a", duration = 1 }, { id = "a", duration = 1 } },
	}
do
	assert(not pcall(Timeline.compile, bad), "invalid timeline must fail before playback")
end
assert(not pcall(Timeline.sample, film, 0 / 0), "NaN seeks must not poison playback")
print("PASS: timeline boundaries, seeking, interpolation, invalid edits")
