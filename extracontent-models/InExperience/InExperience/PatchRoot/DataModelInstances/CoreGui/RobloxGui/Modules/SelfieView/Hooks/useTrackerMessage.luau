local CorePackages = game:GetService("CorePackages")
local Packages = CorePackages.Packages
local React = require(Packages.React)
local LuauPolyfill = require(Packages.LuauPolyfill)
local setTimeout = LuauPolyfill.setTimeout
local clearTimeout = LuauPolyfill.clearTimeout

local useTrackerMode = require(script.Parent.useTrackerMode)
local FaceChatUtils = require(script.Parent.Parent.Utils.FaceChatUtils)
local Localization = require(CorePackages.Workspace.Packages.Localization)
local useLocalization = Localization.Hooks.useLocalization

local TrackerMode = Enum.TrackerMode

return function()
	local ref = React.useRef(FaceChatUtils.getTrackerMode())
	local current = useTrackerMode()

	local v = useLocalization({
		controlMessageSound = "CoreScripts.TopBar.ControlMessageSound",
		controlMessageMotion = "CoreScripts.TopBar.ControlMessageMotion",
		controlMessageOn = "CoreScripts.TopBar.ControlMessageOn",
		controlMessageOff = "CoreScripts.TopBar.ControlMessageOff"
	})

	local state, setState = React.useState({
		visible = false,
		text = v.controlMessageMotion,
		status = v.controlMessageOff
	})
	local ref2 = React.useRef(nil)
	local function fn()
		local _controlMessageMotion = v.controlMessageMotion
		local _controlMessageOff = v.controlMessageOff
		local status, text

		if current == TrackerMode.None then
			status = v.controlMessageOff

			if ref.current == TrackerMode.Audio then
				text = v.controlMessageSound
			else
				text = v.controlMessageMotion
			end
		else
			status = v.controlMessageOn

			if current == TrackerMode.AudioVideo or current == TrackerMode.Video then
				text = v.controlMessageMotion
			else
				text = v.controlMessageSound
			end
		end

		ref.current = current

		return { visible = true, text = text, status = status }
	end

	React.useEffect(function()
		if ref2.current then
			clearTimeout(ref2.current)
		end

		setState(fn())
		ref2.current = setTimeout(function()
			setState({ visible = false, text = state.text, status = state.status })
		end, 2000)
	end, { current })
	return state
end
