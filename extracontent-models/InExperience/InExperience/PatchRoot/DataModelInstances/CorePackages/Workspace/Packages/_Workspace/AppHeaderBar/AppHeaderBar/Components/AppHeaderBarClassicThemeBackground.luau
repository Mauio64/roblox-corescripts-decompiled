local GuiService = game:GetService("GuiService")
local Workspace = game:GetService("Workspace")

local parent = script.Parent.Parent.Parent

local AppNavBar = require(parent.AppNavBar)
local Foundation = require(parent.Foundation)
local React = require(parent.React)
local Responsive = require(parent.Responsive)
local SignalsReact = require(parent.SignalsReact)

local SharedFlags = require(parent.SharedFlags)
local FFlagSplitPaneFixClassicThemeHeader = SharedFlags.FFlagSplitPaneFixClassicThemeHeader
local SplitPane

if FFlagSplitPaneFixClassicThemeHeader then
	SplitPane = require(parent.SplitPane)
else
	SplitPane = nil
end

local splitPaneStore

if FFlagSplitPaneFixClassicThemeHeader then
	splitPaneStore = SplitPane.SplitPaneStore
else
	splitPaneStore = nil
end

local useNavBarPlacement = AppNavBar.useNavBarPlacement
local useNavBarSize = AppNavBar.useNavBarSize
local Placement = AppNavBar.Placement

local useTokens = Foundation.Hooks.useTokens
local Image = Foundation.Image
local View = Foundation.View

local function getScreenWidth() -- 1 equivalent call inferred from this helper
	local currentCamera = Workspace.CurrentCamera

	if currentCamera then
		return currentCamera.ViewportSize.X
	end

	return GuiService:GetScreenResolution().X
end

local function AppHeaderBarClassicThemeBackground(p)
	local v = useTokens()

	local v2 = Responsive.useDeviceInsets()

	local v3 = useNavBarPlacement()
	local v4 = useNavBarSize()
	local v5 = v3 ~= Placement.Left and 0 or v4
	local v6, v7

	if FFlagSplitPaneFixClassicThemeHeader then
		local store = splitPaneStore.getStore()
		v6 = SignalsReact.useSignalState(store.getSupportPaneModeIfActive) == SplitPane.SupportPaneMode.Normal

		v7 = SignalsReact.useSignalState(store.getContentRegionRect)
	else
		v6 = nil
		v7 = nil
	end

	local position, v8 = React.useBinding(UDim2.fromOffset(0, 0))
	local size, v9 = React.useBinding(UDim2.fromOffset(0, 0))

	local ref = React.useRef(nil)

	local useCallback = React.useCallback
	local function fn(current)
		if not current then
			return
		end

		ref.current = current

		local current2 = p.containerRef.current

		if not current2 then
			return
		end

		local vector2 = Vector2.new(-v2.left + v5, -v2.top)
		local v10 = vector2 - current.AbsolutePosition
		local v11

		if FFlagSplitPaneFixClassicThemeHeader and v6 and v7 then
			v11 = v7.Max.X - vector2.X
		else
			v11 = getScreenWidth() + v2.left + v2.right - v5 -- inferred equivalent call
		end

		local v12 = current2.AbsolutePosition.Y + current2.AbsoluteSize.Y - vector2.Y

		v8(UDim2.fromOffset(current.Position.X.Offset + v10.X, current.Position.Y.Offset + v10.Y))

		v9(UDim2.fromOffset(v11, v12))
	end

	local containerRef = p.containerRef
	local left = v2.left
	local top = v2.top
	local right = v2.right
	local v10

	if FFlagSplitPaneFixClassicThemeHeader then
		v10 = v6
	end

	local v11

	if FFlagSplitPaneFixClassicThemeHeader then
		v11 = v7
	end

	local ref2 = useCallback(fn, { v5, containerRef, left, top, right, v10, v11 })

	React.useEffect(function()
		ref2(ref.current)

		local propertyChangedSignals = {}

		local currentCamera = Workspace.CurrentCamera

		if currentCamera then
			table.insert(propertyChangedSignals, currentCamera:GetPropertyChangedSignal("ViewportSize"))
		end

		local current = p.containerRef.current

		if current then
			table.insert(propertyChangedSignals, current:GetPropertyChangedSignal("AbsolutePosition"))
			table.insert(propertyChangedSignals, current:GetPropertyChangedSignal("AbsoluteSize"))
		end

		local connections = {}

		for _, v12 in propertyChangedSignals do
			table.insert(connections, (v12:Connect(function()
				ref2(ref.current)
			end)))
		end

		return function()
			for _, connection in connections do
				connection:Disconnect()
			end
		end
	end, { p.containerRef, ref2 })

	return React.createElement(View, { tag = "size-0", ZIndex = -1 }, {
		Background = React.createElement(View, {
			tag = "clip",
			Position = position,
			Size = size,
			backgroundStyle = v.Color.Extended.White.White_100,
			ref = ref2
		}, {
			Gradient = React.createElement("UIGradient", {
				Rotation = 90,
				Color = ColorSequence.new({
					ColorSequenceKeypoint.new(0, p.config.gradientColor),
					ColorSequenceKeypoint.new(0.33, p.config.gradientColor),
					ColorSequenceKeypoint.new(1, v.Color.Surface.Surface_0.Color3)
				})
			}),
			CenterImage = React.createElement(Image, {
				tag = "position-top-center anchor-top-center size-full",
				Image = p.config.centerImage,
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
