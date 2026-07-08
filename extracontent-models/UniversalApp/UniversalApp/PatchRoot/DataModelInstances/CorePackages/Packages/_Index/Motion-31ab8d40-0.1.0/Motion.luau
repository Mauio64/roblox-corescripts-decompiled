local Motion = require(script.Motion)
local useMotion = require(script.Utility.useMotion)
local AnimatePresence = require(script.AnimatePresence.AnimatePresence)
local usePresence = require(script.AnimatePresence.usePresence)

require(script.Types)

return {
	createState = Motion.createState,
	animate = Motion.animate,
	transition = Motion.transition,
	useMotion = useMotion,
	usePresence = usePresence,
	AnimatePresence = AnimatePresence,
	TransitionPreset = require(script.Enums.TransitionPreset)
}
