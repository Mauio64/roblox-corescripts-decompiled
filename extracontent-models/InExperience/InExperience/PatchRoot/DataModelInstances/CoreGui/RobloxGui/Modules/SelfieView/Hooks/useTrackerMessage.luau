local CorePackages = game:GetService("CorePackages")
local Packages = CorePackages.Packages
local React = require(Packages.React)
local LuauPolyfill = require(Packages.LuauPolyfill)
local setTimeout = LuauPolyfill.setTimeout
local clearTimeout = LuauPolyfill.clearTimeout
local useTrackerMode = require(script.Parent.useTrackerMode)
local FaceChatUtils = require(script.Parent.Parent.Utils.FaceChatUtils)
local useLocalization = require(CorePackages.Workspace.Packages.Localization).Hooks.useLocalization
local TrackerMode = Enum.TrackerMode

return function() -- line: 27
	-- upvalues: React (copy), FaceChatUtils (copy), useTrackerMode (copy), useLocalization (copy), TrackerMode (copy), clearTimeout (copy), setTimeout (copy)
	local v11 = React.useRef(FaceChatUtils.getTrackerMode())
	local v12 = useTrackerMode()
	local v13 = useLocalization({
		controlMessageSound = "CoreScripts.TopBar.ControlMessageSound",
		controlMessageMotion = "CoreScripts.TopBar.ControlMessageMotion",
		controlMessageOn = "CoreScripts.TopBar.ControlMessageOn",
		controlMessageOff = "CoreScripts.TopBar.ControlMessageOff"
	})
	local v14, v15 = React.useState({
		visible = false,
		text = v13.controlMessageMotion,
		status = v13.controlMessageOff
	})
	local v16 = React.useRef(nil)

	local function v17() -- line: 42
		-- upvalues: v13 (copy), v12 (copy), TrackerMode (copy), v11 (copy)
		local _ = v13.controlMessageMotion
		local _ = v13.controlMessageOff
		local controlMessageOn, v21

		if v12 ~= TrackerMode.None then
			controlMessageOn = v13.controlMessageOn
			v21 = if v12 ~= TrackerMode.AudioVideo and v12 ~= TrackerMode.Video then v13.controlMessageSound else v13.controlMessageMotion
		else
			controlMessageOn = v13.controlMessageOff
			v21 = if v11.current ~= TrackerMode.Audio then v13.controlMessageMotion else v13.controlMessageSound
		end

		v11.current = v12

		return {
			visible = true,
			text = v21,
			status = controlMessageOn
		}
	end

	React.useEffect(function() -- line: 75
		-- upvalues: v16 (copy), clearTimeout (copy), v15 (copy), v17 (copy), setTimeout (copy), v14 (copy)
		if v16.current then
			clearTimeout(v16.current)
		end

		v15((v17()))
		v16.current = setTimeout(function() -- line: 81
			-- upvalues: v15 (copy), v14 (copy)
			v15({
				visible = false,
				text = v14.text,
				status = v14.status
			})
		end, 2000)
	end, { v12 })

	return v14
end
