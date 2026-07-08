local Parent = script:FindFirstAncestor("PageLoadTracker").Parent
local React = require(Parent.React)
local useSelector = require(Parent.RoactUtils).Hooks.RoactRodux.useSelector
local SharedFlags = require(Parent.SharedFlags)
local createPageTracker = require(script.Parent.Parent.createPageTracker)
local PageTrackerContext = require(script.Parent.Parent.PageTrackerContext)
local isElementInScreenBounds = require(script.Parent.Parent.isElementInScreenBounds)
local PageLoadConfig = require(script.Parent.Parent.PageLoadConfig)
local VisualDebugManager = require(script.Parent.Parent.VisualDebugManager)
local ExperienceService = require(Parent.ExperienceService).ExperienceService

local function usePageTracker(b1: boolean, s1: string) -- line: 16
	-- upvalues: React (copy), createPageTracker (copy), SharedFlags (copy), ExperienceService (copy)
	local v15 = React.useMemo(function() -- line: 17
		-- upvalues: createPageTracker (copy)
		return createPageTracker()
	end, {})

	if b1 then
		v15:start(s1)
	else
		v15:stop()
	end

	React.useEffect(function() -- line: 27
		-- upvalues: v15 (copy), SharedFlags (copy), ExperienceService (copy)
		v15:sendMilestone("first_react_frame_rendered")

		local u24 = nil

		if SharedFlags.FFlagLuaAppPageLoadTrackerJoinExperienceFix then
			u24 = ExperienceService:RegisterForExperienceJoin(function() -- line: 35
				-- upvalues: v15 (copy)
				v15:stop()
			end)
		end

		return function() -- line: 40
			-- upvalues: v15 (copy), SharedFlags (copy), u24 (ref)
			v15:stop()

			if SharedFlags.FFlagLuaAppPageLoadTrackerJoinExperienceFix and u24 then
				u24:Disconnect()
			end
		end
	end, {})

	return v15
end
local function ComponentTracker(t1: {[any]: any}) -- line: 57
	-- upvalues: usePageTracker (copy), React (copy), SharedFlags (copy), VisualDebugManager (copy), useSelector (copy), PageLoadConfig (copy), isElementInScreenBounds (copy), PageTrackerContext (copy)
	local v17 = usePageTracker(t1.isActive, t1.componentName)
	local v18 = React.useRef(nil)
	local v19 = React.useRef(nil)

	if SharedFlags.FFlagDebugEnablePageLoadTrackerVisualizer and v18.current == nil then
		v18.current = VisualDebugManager.new()
	end

	local v20 = useSelector(function(p1) -- line: 69
		-- upvalues: PageLoadConfig (copy)
		return p1.ScreenSize or PageLoadConfig.SCREEN_BOUNDS.DEFAULT_SCREEN_SIZE
	end)
	local v21 = useSelector(function(p2) -- line: 73
		-- upvalues: PageLoadConfig (copy)
		return p2.TopBar and p2.TopBar.topBarHeight or PageLoadConfig.SCREEN_BOUNDS.DEFAULT_TOP_BAR_HEIGHT
	end)

	local function addTrackingToChild(p3) -- line: 77
		-- upvalues: isElementInScreenBounds (copy), v20 (copy), v21 (copy), v17 (copy), SharedFlags (copy), v18 (copy)
		if not p3:IsA("GuiObject") then
			return
		end

		if isElementInScreenBounds(p3, v20, v21) then
			v17:onComponentAdded(p3)

			if SharedFlags.FFlagDebugEnablePageLoadTrackerVisualizer then
				v18.current:highlightComponent(p3)
			end
		end
	end
	local function setupChildTracking(p4) -- line: 90
		-- upvalues: SharedFlags (copy), isElementInScreenBounds (copy), v20 (copy), v21 (copy), v17 (copy), v18 (copy)
		for _, descendant in p4:GetDescendants() do
			if SharedFlags.FFlagLuaAppImproveComponentTrackingTiming then
				task.defer(function() -- line: 93
					-- upvalues: descendant (copy), isElementInScreenBounds (copy), v20 (copy), v21 (copy), v17 (copy), SharedFlags (copy), v18 (copy)
					local v33 = descendant

					if not v33:IsA("GuiObject") then
						return
					end

					if isElementInScreenBounds(v33, v20, v21) then
						v17:onComponentAdded(v33)

						if SharedFlags.FFlagDebugEnablePageLoadTrackerVisualizer then
							v18.current:highlightComponent(v33)
						end
					end
				end)
			elseif descendant:IsA("GuiObject") and isElementInScreenBounds(descendant, v20, v21) then
				v17:onComponentAdded(descendant)

				if SharedFlags.FFlagDebugEnablePageLoadTrackerVisualizer then
					v18.current:highlightComponent(descendant)
				end
			end
		end

		return (p4.DescendantAdded:Connect(function(descendant) -- line: 100
			-- upvalues: SharedFlags (copy), isElementInScreenBounds (copy), v20 (copy), v21 (copy), v17 (copy), v18 (copy)
			if SharedFlags.FFlagLuaAppImproveComponentTrackingTiming then
				task.defer(function() -- line: 106
					-- upvalues: descendant (copy), isElementInScreenBounds (copy), v20 (copy), v21 (copy), v17 (copy), SharedFlags (copy), v18 (copy)
					local v35 = descendant

					if not v35:IsA("GuiObject") then
						return
					end

					if isElementInScreenBounds(v35, v20, v21) then
						v17:onComponentAdded(v35)

						if SharedFlags.FFlagDebugEnablePageLoadTrackerVisualizer then
							v18.current:highlightComponent(v35)
						end
					end
				end)

				return
			end

			if not descendant:IsA("GuiObject") then
				return
			end

			if isElementInScreenBounds(descendant, v20, v21) then
				v17:onComponentAdded(descendant)

				if SharedFlags.FFlagDebugEnablePageLoadTrackerVisualizer then
					v18.current:highlightComponent(descendant)
				end
			end
		end))
	end

	if SharedFlags.FFlagDebugEnablePageLoadTrackerVisualizer then
		React.useEffect(function() -- line: 117
			-- upvalues: v18 (copy)
			return function() -- line: 118
				-- upvalues: v18 (copy)
				v18.current:destroy()
			end
		end, {})
	end

	React.useLayoutEffect(function() -- line: 124
		-- upvalues: t1 (copy), v19 (copy), setupChildTracking (copy), SharedFlags (copy), v17 (copy)
		if t1.isActive then
			local current = v19.current
			local v32 = setupChildTracking(current)

			if SharedFlags.FFlagPageLoadAllowImprovedDisconnectTiming then
				v17.onCompleteSignal:connect(function() -- line: 129
					-- upvalues: v32 (copy)
					v32:Disconnect()
				end)

				return
			end

			return function() -- line: 134
				-- upvalues: v32 (copy)
				v32:Disconnect()
			end
		end
	end, { t1.isActive })

	return React.createElement("Frame", {
		BackgroundTransparency = 1,
		ref = v19,
		Size = UDim2.fromScale(1, 1)
	}, {
		PageTrackerContext = React.createElement(PageTrackerContext.Provider, {
			value = v17
		}, t1.children)
	})
end

return ComponentTracker
