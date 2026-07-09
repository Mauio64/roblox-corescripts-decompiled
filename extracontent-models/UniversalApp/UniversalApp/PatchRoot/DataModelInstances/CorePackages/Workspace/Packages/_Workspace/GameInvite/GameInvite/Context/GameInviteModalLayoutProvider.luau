local GuiService = game:GetService("GuiService")
local GameInvite = script:FindFirstAncestor("GameInvite")
local Context = GameInvite.Context
local GameInviteParent = GameInvite.Parent
local SharedFlags = require(GameInviteParent.SharedFlags)
local React = require(GameInviteParent.React)

require(GameInvite.gameInviteModalType)

local GameInviteModalLayoutContext = require(Context.GameInviteModalLayoutContext)
local GetFFlagLuaAppEnableTopBanner = SharedFlags.GetFFlagLuaAppEnableTopBanner
local isInExperienceUIVREnabled = require(GameInviteParent.SharedExperimentDefinition).isInExperienceUIVREnabled
local FFlagEnableInExperienceUIPCVRFix = SharedFlags.FFlagEnableInExperienceUIPCVRFix

local function v11(p1, p2) -- line: 59
	-- upvalues: GetFFlagLuaAppEnableTopBanner (copy), GuiService (copy)
	local uDim = UDim.new(0, not (not (p1.X < 800) and not (p1.Y < 624)) and p1.X or 800)
	local new = UDim.new
	local g26 = nil
	local v29 = nil

	repeat
		if g26 or (p1.X < 800 or p1.Y < 624) then
			if not g26 then
				local p1Y = p1.Y
				local n1 = 0

				if not GetFFlagLuaAppEnableTopBanner() or p2 then
					n1 = not GuiService and 50 or GuiService:GetGuiInset().Y
				end

				v29 = p1Y - n1
			end

			if g26 or v29 then
				g26 = false

				local v30 = new(0, v29)

				return UDim2.new(uDim, v30)
			end
		end

		v29 = 624
		g26 = true
	until not g26
end

return function(t1: {[any]: any}) -- line: 69
	-- upvalues: isInExperienceUIVREnabled (copy), FFlagEnableInExperienceUIPCVRFix (copy), React (copy), v11 (copy), GameInviteModalLayoutContext (copy)
	local isCoreScript = t1.isCoreScript
	local v34 = if not isInExperienceUIVREnabled or (not FFlagEnableInExperienceUIPCVRFix or not t1.screenSizeOverride) then workspace.CurrentCamera.ViewportSize else t1.screenSizeOverride
	local v35, v36 = React.useState(v11(v34, isCoreScript))
	local v37, v38 = React.useState(v34.Y < 624)
	local v39, v40 = React.useState(v34.X < 800)
	local v41, v42 = React.useState(not (v34.X < 800) and not (v34.Y < 624) and "default" or "compact")
	local v43 = not FFlagEnableInExperienceUIPCVRFix and function() -- line: 94
		-- upvalues: v11 (copy), isCoreScript (copy), v38 (copy), v40 (copy), v36 (copy), v42 (copy)
		local ViewportSize = workspace.CurrentCamera.ViewportSize
		local v49 = ViewportSize.Y < 624
		local v50 = ViewportSize.X < 800
		local v51 = v11(ViewportSize, isCoreScript)

		v38(v49)
		v40(v50)
		v36(v51)
		v42(not (ViewportSize.X < 800) and not (ViewportSize.Y < 624) and "default" or "compact")
	end or React.useCallback(function() -- line: 83
		-- upvalues: v11 (copy), isCoreScript (copy), v38 (copy), v40 (copy), v36 (copy), v42 (copy)
		local ViewportSize = workspace.CurrentCamera.ViewportSize
		local v45 = ViewportSize.Y < 624
		local v46 = ViewportSize.X < 800
		local v47 = v11(ViewportSize, isCoreScript)

		v38(v45)
		v40(v46)
		v36(v47)
		v42(not (ViewportSize.X < 800) and not (ViewportSize.Y < 624) and "default" or "compact")
	end, { isCoreScript })

	React.useEffect(function() -- line: 107
		-- upvalues: isInExperienceUIVREnabled (copy), FFlagEnableInExperienceUIPCVRFix (copy), t1 (copy), v43 (copy)
		if isInExperienceUIVREnabled and (FFlagEnableInExperienceUIPCVRFix and t1.screenSizeOverride) then
			return function() -- line: 111
			end
		end

		v43()

		local connection = workspace.CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(v43)

		return function() -- line: 119
			-- upvalues: connection (copy)
			if connection then
				connection:Disconnect()
			end
		end
	end, if not isInExperienceUIVREnabled or not FFlagEnableInExperienceUIPCVRFix then {} else {
		t1.screenSizeOverride,
		v43
	})

	return React.createElement(GameInviteModalLayoutContext.Provider, {
		value = {
			isFullHeight = v37,
			isFullWidth = v39,
			modalSize = v35,
			modalMode = v41
		}
	}, t1.children)
end
