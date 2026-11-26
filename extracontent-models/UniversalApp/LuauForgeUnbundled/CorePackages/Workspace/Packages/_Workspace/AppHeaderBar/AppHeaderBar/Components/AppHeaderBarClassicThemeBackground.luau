local GuiService = game:GetService("GuiService")
local Workspace = game:GetService("Workspace")

local AppNavBar = require("@game/CorePackages/Workspace/Packages/_Workspace/AppHeaderBar/AppNavBar")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/AppHeaderBar/Foundation")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AppHeaderBar/React")
local Responsive = require("@game/CorePackages/Workspace/Packages/_Workspace/AppHeaderBar/Responsive")
local SignalsReact = require("@game/CorePackages/Workspace/Packages/_Workspace/AppHeaderBar/SignalsReact")

local fFlagSplitPaneFixClassicThemeHeader = require("@game/CorePackages/Workspace/Packages/_Workspace/AppHeaderBar/SharedFlags").FFlagSplitPaneFixClassicThemeHeader

local v5 = if fFlagSplitPaneFixClassicThemeHeader then require("@game/CorePackages/Workspace/Packages/_Workspace/AppHeaderBar/SplitPane") else nil
local splitPaneStore = if fFlagSplitPaneFixClassicThemeHeader then v5.SplitPaneStore else nil

local useNavBarPlacement = AppNavBar.useNavBarPlacement
local useNavBarSize = AppNavBar.useNavBarSize
local placement = AppNavBar.Placement

local useTokens = Foundation.Hooks.useTokens
local image = Foundation.Image
local view = Foundation.View

local function getScreenWidth()
	local currentCamera = Workspace.CurrentCamera

	if currentCamera then
		return currentCamera.ViewportSize.X
	end

	return GuiService:GetScreenResolution().X
end

local function AppHeaderBarClassicThemeBackground(p2)
	local v6 = useTokens()

	local v7 = Responsive.useDeviceInsets()

	local v8 = useNavBarPlacement()
	local v9 = useNavBarSize()
	local v10 = v8 ~= placement.Left and 0 or v9
	local v11, v12

	if fFlagSplitPaneFixClassicThemeHeader then
		local store = splitPaneStore.getStore()
		v11 = SignalsReact.useSignalState(store.getSupportPaneModeIfActive) == v5.SupportPaneMode.Normal

		v12 = SignalsReact.useSignalState(store.getContentRegionRect)
	else
		v11 = nil
		v12 = nil
	end

	local v13, v14 = React.useBinding(UDim2.fromOffset(0, 0))
	local v15, v16 = React.useBinding(UDim2.fromOffset(0, 0))

	local ref = React.useRef(nil)

	local useCallback = React.useCallback
	local function fn(current)
		if not current then
			return
		end

		ref.current = current

		local current2 = p2.containerRef.current

		if not current2 then
			return
		end

		local vector2 = Vector2.new(-v7.left + v10, -v7.top)
		local v17 = vector2 - current.AbsolutePosition
		local v18

		if fFlagSplitPaneFixClassicThemeHeader and v11 and v12 then
			v18 = v12.Max.X - vector2.X
		else
			local currentCamera = Workspace.CurrentCamera
			v18 = (if currentCamera then currentCamera.ViewportSize.X else GuiService:GetScreenResolution().X) + v7.left + v7.right - v10
		end

		local v19 = current2.AbsolutePosition.Y + current2.AbsoluteSize.Y - vector2.Y

		v14(UDim2.fromOffset(current.Position.X.Offset + v17.X, current.Position.Y.Offset + v17.Y))

		v16(UDim2.fromOffset(v18, v19))
	end

	local containerRef = p2.containerRef
	local left = v7.left
	local top = v7.top
	local right = v7.right
	local v18 = if fFlagSplitPaneFixClassicThemeHeader then v11 else nil
	local v20 = useCallback(fn, {
		v10,
		containerRef,
		left,
		top,
		right,
		v18,
		if fFlagSplitPaneFixClassicThemeHeader then v12 else nil
	})

	React.useEffect(function()
		v20(ref.current)

		local propertyChangedSignals = {}

		local currentCamera = Workspace.CurrentCamera

		if currentCamera then
			table.insert(propertyChangedSignals, currentCamera:GetPropertyChangedSignal("ViewportSize"))
		end

		local current = p2.containerRef.current

		if current then
			table.insert(propertyChangedSignals, current:GetPropertyChangedSignal("AbsolutePosition"))
			table.insert(propertyChangedSignals, current:GetPropertyChangedSignal("AbsoluteSize"))
		end

		local connections = {}

		for k, v21 in propertyChangedSignals do
			table.insert(connections, (v21:Connect(function()
				v20(ref.current)
			end)))
		end

		return function()
			for k, connection in connections do
				connection:Disconnect()
			end
		end
	end, { p2.containerRef, v20 })

	return React.createElement(view, { tag = "size-0", ZIndex = -1 }, {
		Background = React.createElement(view, {
			tag = "clip",
			Position = v13,
			Size = v15,
			backgroundStyle = v6.Color.Extended.White.White_100,
			ref = v20
		}, {
			Gradient = React.createElement("UIGradient", {
				Rotation = 90,
				Color = ColorSequence.new({
					ColorSequenceKeypoint.new(0, p2.config.gradientColor),
					ColorSequenceKeypoint.new(0.33, p2.config.gradientColor),
					ColorSequenceKeypoint.new(1, v6.Color.Surface.Surface_0.Color3)
				})
			}),
			CenterImage = React.createElement(image, {
				tag = "position-top-center anchor-top-center size-full",
				Image = p2.config.centerImage,
				ScaleType = Enum.ScaleType.Stretch,
				sizeConstraint = {
					MinSize = Vector2.new(960, 0),
					MaxSize = Vector2.new(1920, 1e999)
				}
			})
		})
	})
end

return React.memo(AppHeaderBarClassicThemeBackground)
