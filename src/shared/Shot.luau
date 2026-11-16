--!strict
local Shot = {}
function Shot.actor(x, y, z, pose, to, yaw, face)
	return { position = { x, y, z }, to = to, pose = pose or "idle", yaw = yaw or 0, face = face or "neutral" }
end
function Shot.prop(x, y, z, to, yaw)
	return { position = { x, y, z }, to = to, yaw = yaw or 0 }
end
function Shot.camera(x, y, z, tx, ty, tz, to)
	return { position = { x, y, z }, target = { tx, ty, tz }, to = to, fov = 48 }
end
function Shot.make(id, duration, text, camera, actors, props, options)
	local shot = options or {}
	shot.id, shot.duration, shot.text, shot.camera = id, duration, text, camera
	shot.actors, shot.props = actors or {}, props or {}
	return shot
end
return Shot
