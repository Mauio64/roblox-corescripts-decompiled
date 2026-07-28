local BuildExperience = script:FindFirstAncestor("BuildExperience")
local BuildExperienceParent = BuildExperience.Parent
local Foundation = require(BuildExperienceParent.Foundation)
local React = require(BuildExperienceParent.React)
local ReactRoblox = require(BuildExperienceParent.ReactRoblox)
local SignalsReact = require(BuildExperienceParent.SignalsReact)
local BuildPillMenu = require(script.Parent.BuildPillMenu)
local BuildPillMenuPageHost = require(script.Parent.BuildPillMenuPageHost)
local GetBuildPillMenuPortalStore = require(BuildExperience.Stores.GetBuildPillMenuPortalStore)
local View = Foundation.View
local useOverlay = Foundation.Hooks.useOverlay
local useStyleSheet = Foundation.Hooks.useStyleSheet

local function getOverlayPosition(p1, p2) -- line: 27
	local v17 = if not p2:IsA("GuiObject") then Vector2.zero else p2.AbsolutePosition
	local v18 = p1.AbsolutePosition - v17

	return UDim2.fromOffset(v18.X, v18.Y)
end
local function BuildPillMenuPortal(t1: {[any]: any}) -- line: 34
	-- upvalues: GetBuildPillMenuPortalStore (copy), SignalsReact (copy), useOverlay (copy), useStyleSheet (copy), React (copy), View (copy), BuildPillMenu (copy), ReactRoblox (copy), BuildPillMenuPageHost (copy)
	local v20 = GetBuildPillMenuPortalStore()
	local v21 = SignalsReact.useSignalState(v20.getPortalTarget)
	local v22 = useOverlay()
	local v23 = useStyleSheet()
	local v24 = React.useRef(nil)
	local v25, v26 = React.useState(nil)
	local v27 = React.useCallback(function() -- line: 42
		-- upvalues: v24 (copy), v21 (copy), v22 (copy)
		local current = v24.current

		if v21 == nil or (v22 == nil or current == nil) then
			return
		end

		local v37 = v21
		local v38 = v22
		local v39 = if not v38:IsA("GuiObject") then Vector2.zero else v38.AbsolutePosition
		local v40 = v37.AbsolutePosition - v39

		current.Position = UDim2.fromOffset(v40.X, v40.Y)
	end, {
		v21,
		v22
	})
	local v28 = React.useCallback(function(p3) -- line: 51
		-- upvalues: v24 (copy), v27 (copy)
		v24.current = p3
		v27()
	end, { v27 })
	local v29 = React.useCallback(function(p4) -- line: 56
		-- upvalues: v26 (copy)
		v26({
			type = "overflow",
			page = p4
		})
	end, {})
	local v30 = React.useCallback(function() -- line: 63
		-- upvalues: v26 (copy)
		v26({
			type = "agents"
		})
	end, {})
	local v31 = React.useCallback(function() -- line: 69
		-- upvalues: v26 (copy)
		v26({
			type = "invitePicker"
		})
	end, {})
	local v32 = React.useCallback(function() -- line: 75
		-- upvalues: v26 (copy)
		v26({
			type = "playtestManagement"
		})
	end, {})
	local v33 = React.useCallback(function() -- line: 81
		-- upvalues: v26 (copy)
		v26({
			type = "creator-credit"
		})
	end, {})
	local v34 = React.useCallback(function() -- line: 87
		-- upvalues: v26 (copy)
		v26(nil)
	end, {})

	React.useLayoutEffect(function() -- line: 91
		-- upvalues: v21 (copy), v22 (copy), v27 (copy)
		if v21 == nil or v22 == nil then
			return
		end

		v27()

		local connection = v21:GetPropertyChangedSignal("AbsolutePosition"):Connect(v27)
		local v44 = if not v22:IsA("GuiObject") then nil else v22:GetPropertyChangedSignal("AbsolutePosition"):Connect(v27)

		return function() -- line: 104
			-- upvalues: connection (copy), v44 (copy)
			connection:Disconnect()

			if v44 ~= nil then
				v44:Disconnect()
			end
		end
	end, {
		v21,
		v22,
		v27
	})

	if v21 == nil or v22 == nil then
		return nil
	end

	local v35 = React.createElement(React.Fragment, nil, {
		StyleLink = React.createElement("StyleLink", {
			StyleSheet = v23
		}),
		Container = React.createElement(View, {
			ZIndex = 999,
			tag = "auto-xy",
			testId = "build-pill-menu-overlay-container",
			AnchorPoint = v21.AnchorPoint,
			ref = v28
		}, {
			Pill = React.createElement(BuildPillMenu, {
				target = t1.target,
				testId = t1.testId,
				onOpenPage = v29,
				onOpenInvitePicker = v31,
				onOpenAgentsPage = v30,
				onOpenCreatorCreditPage = v33
			})
		})
	})

	return React.createElement(React.Fragment, nil, {
		Pill = ReactRoblox.createPortal(v35, v22),
		Page = React.createElement(BuildPillMenuPageHost, {
			activePage = v25,
			target = t1.target,
			onClose = v34,
			onInvitesSent = v32,
			onOpenInvitePicker = v31
		})
	})
end

return React.memo(BuildPillMenuPortal)
