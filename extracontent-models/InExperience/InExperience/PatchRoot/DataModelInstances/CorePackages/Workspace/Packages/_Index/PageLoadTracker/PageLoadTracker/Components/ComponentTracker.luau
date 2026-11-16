local parent = script:FindFirstAncestor("PageLoadTracker").Parent
local React = require(parent.React)

local RoactUtils = require(parent.RoactUtils)
local useSelector = RoactUtils.Hooks.RoactRodux.useSelector
local SharedFlags = require(parent.SharedFlags)

local createPageTracker = require(script.Parent.Parent.createPageTracker)
local PageTrackerContext = require(script.Parent.Parent.PageTrackerContext)
local isElementInScreenBounds = require(script.Parent.Parent.isElementInScreenBounds)
local PageLoadConfig = require(script.Parent.Parent.PageLoadConfig)
local VisualDebugManager = require(script.Parent.Parent.VisualDebugManager)

local ExperienceService = require(parent.ExperienceService)
local experienceService = ExperienceService.ExperienceService

local function usePageTracker(isActive: boolean, componentName: string)
	local v = React.useMemo(function()
		return createPageTracker()
	end, {})

	if isActive then
		v:start(componentName)
	else
		v:stop()
	end

	React.useEffect(function()
		v:sendMilestone("first_react_frame_rendered")
		local connection

		if SharedFlags.FFlagLuaAppPageLoadTrackerJoinExperienceFix then
			connection = experienceService:RegisterForExperienceJoin(function()
				v:stop()
			end)
		else
			connection = nil
		end

		return function()
			v:stop()

			if SharedFlags.FFlagLuaAppPageLoadTrackerJoinExperienceFix and connection then
				connection:Disconnect()
			end
		end
	end, {})

	return v
end

local function ComponentTracker(props)
	local v = usePageTracker(props.isActive, props.componentName)

	local ref = React.useRef(nil)
	local ref2 = React.useRef(nil)

	if SharedFlags.FFlagDebugEnablePageLoadTrackerVisualizer and ref.current == nil then
		ref.current = VisualDebugManager.new()
	end

	local v2 = useSelector(function(p)
		return p.ScreenSize or PageLoadConfig.SCREEN_BOUNDS.DEFAULT_SCREEN_SIZE
	end)

	local v3 = useSelector(function(p)
		return p.TopBar and p.TopBar.topBarHeight or PageLoadConfig.SCREEN_BOUNDS.DEFAULT_TOP_BAR_HEIGHT
	end)

	local function addTrackingToChild(guiObject) -- 4 equivalent calls inferred from this helper
		if not guiObject:IsA("GuiObject") then
			return
		end

		if isElementInScreenBounds(guiObject, v2, v3) then
			v:onComponentAdded(guiObject)

			if SharedFlags.FFlagDebugEnablePageLoadTrackerVisualizer then
				ref.current:highlightComponent(guiObject)
			end
		end
	end

	local function setupChildTracking(folder)
		for _, descendant in folder:GetDescendants() do
			if SharedFlags.FFlagLuaAppImproveComponentTrackingTiming then
				task.defer(function()
					addTrackingToChild(descendant) -- inferred equivalent call
				end)
			else
				addTrackingToChild(descendant) -- inferred equivalent call
			end
		end

		return (folder.DescendantAdded:Connect(function(descendant)
			if SharedFlags.FFlagLuaAppImproveComponentTrackingTiming then
				task.defer(function()
					addTrackingToChild(descendant) -- inferred equivalent call
				end)
				return
			end

			addTrackingToChild(descendant) -- inferred equivalent call
		end))
	end

	if SharedFlags.FFlagDebugEnablePageLoadTrackerVisualizer then
		React.useEffect(function()
			return function()
				ref.current:destroy()
			end
		end, {})
	end

	React.useLayoutEffect(function()
		if not props.isActive then
			return
		end

		local connection = setupChildTracking(ref2.current)

		if not SharedFlags.FFlagPageLoadAllowImprovedDisconnectTiming then
			return function()
				connection:Disconnect()
			end
		end

		v.onCompleteSignal:connect(function()
			connection:Disconnect()
		end)
	end, { props.isActive })

	return React.createElement("Frame", {
		ref = ref2,
		Size = UDim2.fromScale(1, 1),
		BackgroundTransparency = 1
	}, {
		PageTrackerContext = React.createElement(PageTrackerContext.Provider, { value = v }, props.children)
	})
end

return ComponentTracker
