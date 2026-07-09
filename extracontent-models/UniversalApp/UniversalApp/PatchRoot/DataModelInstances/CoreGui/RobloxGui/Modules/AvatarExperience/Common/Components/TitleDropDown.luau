local CorePackages = game:GetService("CorePackages")
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local Cryo = require(CorePackages.Packages.Cryo)
local React = require(CorePackages.Packages.React)
local Roact = require(CorePackages.Packages.Roact)
local t = require(CorePackages.Packages.t)
local UIBlox = require(CorePackages.Packages.UIBlox)
local FocusNavigationUtils = require(CorePackages.Workspace.Packages.FocusNavigationUtils)
local ReactFocusNavigation = require(CorePackages.Packages.ReactFocusNavigation)
local InputHandlers = require(CorePackages.Packages.InputHandlers)
local FocusNavigationEventNameEnum = FocusNavigationUtils.FocusNavigationEventNameEnum
local useTableWrappedCallbackRef = require(CorePackages.Workspace.Packages.AvatarExperienceCommon).Utils.RoactGamepadMigration.useTableWrappedCallbackRef
local Utils = require(Modules.AvatarExperience.Common.Utils)
local TextButton = UIBlox.App.Button.TextButton
local CursorKind = UIBlox.App.SelectionImage.CursorKind
local withSelectionCursorProvider = UIBlox.App.SelectionImage.withSelectionCursorProvider
local withStyle = UIBlox.Style.withStyle
local Images = UIBlox.App.ImageSet.Images
local ControlState = UIBlox.Core.Control.Enum.ControlState
local ImageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel
local Interactable = UIBlox.Core.Control.Interactable
local v22 = Images["icons/actions/truncationExpand"]
local t1 = {
	[Enum.KeyCode.ButtonA] = FocusNavigationEventNameEnum.ActivateTitleDropDown
}

local function useTitleDropDownFocusNavigationBindings(p1, p2: ((...any) -> ...any)) -- line: 42
	-- upvalues: ReactFocusNavigation (copy), t1 (copy), React (copy), FocusNavigationEventNameEnum (copy), InputHandlers (copy)
	local v28 = ReactFocusNavigation.useEventMap(t1, p1)
	local v29 = React.useMemo(function() -- line: 44
		-- upvalues: FocusNavigationEventNameEnum (copy), InputHandlers (copy), p2 (copy)
		return {
			[FocusNavigationEventNameEnum.ActivateTitleDropDown] = {
				handler = InputHandlers.onRelease(p2)
			}
		}
	end, { p2 })

	return ReactFocusNavigation.useEventHandlerMap(v29, v28)
end

local v25 = Roact.PureComponent:extend("TitleDropDown")

v25.validateProps = t.strictInterface({
	onActivated = t.callback,
	Text = t.string,
	NextSelectionRight = t.optional(t.table),
	forwardRef = t.optional(t.table),
	inputBindings = t.optional(t.table)
})

function v25.init(p3) -- line: 66
	-- upvalues: Roact (copy), ControlState (copy)
	p3:setState({
		wrappingFrameAbsoluteSizeX = 0
	})

	function p3.absoluteSizeChanged(p4) -- line: 71
		-- upvalues: p3 (copy)
		p3:setState({
			wrappingFrameAbsoluteSizeX = p4.AbsoluteSize.X
		})
	end

	p3.wrappingFrameRef = Roact.createRef()

	local v31, v32 = Roact.createBinding(false)

	p3.useBackgroundTransparency = v31
	p3.updateUseBackgroundTransparency = v32

	function p3.onStateChanged(_, p6) -- line: 87
		-- upvalues: ControlState (copy), p3 (copy)
		if p6 == ControlState.Pressed or p6 == ControlState.Hover then
			p3.updateUseBackgroundTransparency(true)

			return
		end

		p3.updateUseBackgroundTransparency(false)
	end
end
function v25.render(p7) -- line: 96
	-- upvalues: withStyle (copy), withSelectionCursorProvider (copy)
	return withStyle(function(p8) -- line: 97
		-- upvalues: withSelectionCursorProvider (copy), p7 (copy)
		return withSelectionCursorProvider(function(p9) -- line: 98
			-- upvalues: p7 (copy), p8 (copy)
			return p7:renderWithProviders(p8, p9)
		end)
	end)
end
function v25.renderLabel(p10, _, _) -- line: 104
	-- upvalues: Roact (copy), TextButton (copy)
	return Roact.createElement(TextButton, {
		layoutOrder = 1,
		fontStyle = "Header1",
		size = UDim2.fromScale(0, 1),
		onActivated = p10.props.onActivated,
		text = p10.props.Text
	})
end
function v25.renderButton(p13, p14, p15) -- line: 114
	-- upvalues: Utils (copy), Roact (copy), ImageSetLabel (copy), v22 (copy), Interactable (copy)
	local propsText = p13.props.Text
	local TextEmphasis = p14.TextEmphasis
	local Header1 = p15.Header1
	local v43 = 28 * Header1.RelativeSize
	local v44 = p15.BaseSize * Header1.RelativeSize
	local BackgroundOnHoverColor = p14.BackgroundOnHover.Color
	local wrappingFrameAbsoluteSizeX = p13.state.wrappingFrameAbsoluteSizeX
	local v47 = wrappingFrameAbsoluteSizeX > 0
	local v48 = math.max(wrappingFrameAbsoluteSizeX - v43, 0)
	local v49, v50 = Utils.getLargestPossibleOneLineTextSize(propsText, v44, Header1, v48)

	if v49 == nil then
		return nil
	end

	local uDim2 = UDim2.fromOffset(v49.X, v49.Y)
	local t2 = {}

	if v47 then
		t2 = {{
			Padding = Roact.createElement("UIPadding", {
				PaddingLeft = UDim.new(0, 8),
				PaddingRight = UDim.new(0, 8)
			}),
			Corner = Roact.createElement("UICorner", {
				CornerRadius = UDim.new(0, 8)
			}),
			UIListLayout = Roact.createElement("UIListLayout", {
				FillDirection = Enum.FillDirection.Horizontal,
				HorizontalAlignment = Enum.HorizontalAlignment.Center,
				VerticalAlignment = Enum.VerticalAlignment.Center,
				SortOrder = Enum.SortOrder.LayoutOrder
			}),
			TextLabel = Roact.createElement("TextLabel", {
				LayoutOrder = 1,
				TextWrapped = 1,
				BackgroundTransparency = 1,
				TextColor3 = TextEmphasis.Color,
				TextTransparency = TextEmphasis.Transparency,
				Font = Header1.Font,
				Text = propsText,
				TextXAlignment = Enum.TextXAlignment.Center,
				TextYAlignment = Enum.TextYAlignment.Center,
				Size = uDim2,
				TextSize = v50
			}),
			Icon = Roact.createElement(ImageSetLabel, {
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				LayoutOrder = 2,
				AnchorPoint = Vector2.new(0.5, 0.5),
				Image = v22,
				ImageColor3 = TextEmphasis.Color,
				Position = UDim2.fromScale(0.5, 0.5),
				Size = UDim2.fromOffset(v43, v43)
			})
		}}
	end

	return Roact.createElement("Frame", {
		BackgroundTransparency = 1,
		Size = UDim2.fromScale(1, 1),
		[Roact.Change.AbsoluteSize] = p13.absoluteSizeChanged,
		[Roact.Ref] = p13.wrappingFrameRef
	}, {
		Interactable = Roact.createElement(Interactable, {
			onStateChanged = p13.onStateChanged,
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			[Roact.Event.Activated] = p13.props.onActivated,
			Size = UDim2.fromScale(1, 1)
		}, {
			ButtonContentFrame = Roact.createElement("Frame", {
				BackgroundColor3 = BackgroundOnHoverColor,
				BackgroundTransparency = p13.useBackgroundTransparency:map(function(p16) -- line: 206
					-- upvalues: p14 (copy)
					if p16 then
						return p14.BackgroundOnHover.Transparency
					end

					return 1
				end),
				AutomaticSize = Enum.AutomaticSize.XY,
				AnchorPoint = Vector2.new(0.5, 0.5),
				Position = UDim2.fromScale(0.5, 0.5)
			}, t2)
		})
	})
end
function v25.didUpdate(p17) -- line: 217
	if p17.wrappingFrameRef.current then
		local _ = p17.wrappingFrameRef.current.AbsoluteSize
	end
end
function v25.renderWithProviders(p18, p19, p20) -- line: 227
	-- upvalues: Roact (copy), CursorKind (copy)
	local Theme = p19.Theme
	local p19Font = p19.Font
	local forwardRef = p18.props.forwardRef

	return Roact.createElement("Frame", {
		Size = UDim2.fromScale(1, 1),
		BackgroundTransparency = 1,
		SelectionImageObject = p20(CursorKind.RoundedRectNoInset),
		NextSelectionRight = p18.props.NextSelectionRight,
		[Roact.Ref] = forwardRef
	}, {
		Padding = Roact.createElement("UIPadding", {
			PaddingLeft = UDim.new(0, 2),
			PaddingRight = UDim.new(0, 8)
		}),
		Button = p18:renderButton(Theme, p19Font)
	})
end

return Roact.forwardRef(function(p21, p22) -- line: 248
	-- upvalues: React (copy), useTitleDropDownFocusNavigationBindings (copy), useTableWrappedCallbackRef (copy), Roact (copy), v25 (copy), Cryo (copy)
	local v63 = React.useCallback(function() -- line: 249
		-- upvalues: p21 (copy)
		p21.onActivated()
	end, { p21.onActivated })
	local v64 = useTitleDropDownFocusNavigationBindings(p22, v63)
	local v65 = useTableWrappedCallbackRef(v64)

	return Roact.createElement(v25, Cryo.Dictionary.join(p21, {
		forwardRef = v65
	}))
end)
