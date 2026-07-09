local AuthCommon = script:FindFirstAncestor("AuthCommon")
local AuthCommonParent = AuthCommon.Parent
local AppFonts = require(AuthCommonParent.Style).AppFonts
local Roact = require(AuthCommonParent.Roact)
local RoactRodux = require(AuthCommonParent.RoactRodux)
local RoactServices = require(AuthCommonParent.RoactServices).RoactServices
local RoactNetworking = require(AuthCommonParent.RoactServiceTags).RoactNetworking
local UIBlox = require(AuthCommonParent.UIBlox)
local withLocalization = require(AuthCommonParent.Localization).withLocalization
local FormFactor = require(AuthCommonParent.FormFactor).Enums.FormFactor
local ImageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel
local GetImageData = require(AuthCommonParent.RobloxAppAssets).GetImageData
local ImageSetButton = UIBlox.Core.ImageSet.ImageSetButton
local SearchBar = require(AuthCommon.Components.SearchBar)
local WindowedListFrame = require(AuthCommon.Components.WindowedListFrame)
local Colors = require(AuthCommonParent.Style).Colors
local Otter = require(AuthCommonParent.Otter)
local v18 = Roact.PureComponent:extend("ListSearchWidget")
local Flint = Colors.Flint
local Obsidian = Colors.Obsidian
local White = Colors.White

function v18.init(p1) -- line: 40
	-- upvalues: Roact (copy), ImageSetLabel (copy), GetImageData (copy), Flint (copy), ImageSetButton (copy)
	p1.state = {
		fullLoad = false,
		visible = false,
		filteredList = p1.props.List
	}
	p1.visibility = 0
	p1.visibilityTarget = 0
	p1.baseFrameRef = Roact.createRef()

	function p1.getWidgetPosition() -- line: 51
		-- upvalues: p1 (copy)
		return UDim2.new(0.5, 0, 2 - p1.visibility, 10)
	end
	function p1.searchTextChanged(p2) -- line: 55
		-- upvalues: p1 (copy)
		local v41 = string.lower(p2.Text)

		if v41 == "" then
			if p1.state.filteredList ~= p1.props.List then
				p1:setState({
					filteredList = p1.props.List
				})

				return
			end
		else
			local t1 = {}

			for _, v in ipairs(p1.props.List) do
				if string.find(string.lower(v.localizedName), v41, 1, true) then
					table.insert(t1, v)
				end
			end

			p1:setState({
				filteredList = t1
			})
		end
	end
	function p1.renderWidgetBackground(p3) -- line: 76
		-- upvalues: Roact (copy), ImageSetLabel (copy), GetImageData (copy), Flint (copy), p1 (copy), ImageSetButton (copy)
		local v46 = 1.4 * p3.closeButtonSize

		if p3.isWideScreen then
			return Roact.createElement(ImageSetLabel, {
				Size = UDim2.new(1, 0, 1, -v46 + 10),
				Position = p3.Position,
				AnchorPoint = Vector2.new(0.5, 1),
				BackgroundTransparency = 1,
				Image = GetImageData("LuaApp/buttons/buttonFill") or "LuaApp/buttons/buttonFill",
				ImageColor3 = Flint,
				BorderSizePixel = 0,
				ScaleType = Enum.ScaleType.Slice,
				SliceCenter = Rect.new(8, 8, 9, 9),
				Visible = p3.Visible,
				[Roact.Ref] = p1.baseFrameRef
			}, {
				CloseButton = Roact.createElement(ImageSetButton, {
					Size = UDim2.new(0, p3.closeButtonSize, 0, p3.closeButtonSize),
					AnchorPoint = Vector2.new(0, 1),
					Image = GetImageData("LuaApp/icons/GameDetails/navigation/close") or "LuaApp/icons/GameDetails/navigation/close",
					BackgroundTransparency = 1,
					[Roact.Event.Activated] = p3.CloseCallback
				}),
				UISizeConstraint = Roact.createElement("UISizeConstraint", {
					MaxSize = Vector2.new(600, 1e999)
				}),
				ContentWrapper = Roact.createElement("Frame", {
					BackgroundTransparency = 1,
					Size = UDim2.new(1, -80, 1, -50),
					Position = UDim2.new(0, 40, 0, 40)
				}, p3.contents)
			})
		end

		local v47 = p3.closeButtonSize + 20

		return Roact.createElement("Frame", {
			Size = UDim2.new(1, 0, 1, 10),
			Position = p3.Position,
			AnchorPoint = Vector2.new(0.5, 1),
			BackgroundColor3 = Flint,
			Visible = p3.Visible,
			[Roact.Ref] = p1.baseFrameRef
		}, {
			UIPadding = Roact.createElement("UIPadding", {
				PaddingTop = UDim.new(0, 40),
				PaddingLeft = UDim.new(0, 20),
				PaddingRight = UDim.new(0, 20),
				PaddingBottom = UDim.new(0, 10)
			}),
			CloseButton = Roact.createElement(ImageSetButton, {
				Size = UDim2.new(0, p3.closeButtonSize, 0, p3.closeButtonSize),
				Image = GetImageData("LuaApp/icons/GameDetails/navigation/close") or "LuaApp/icons/GameDetails/navigation/close",
				BackgroundTransparency = 1,
				AnchorPoint = Vector2.new(0.21, 0),
				[Roact.Event.Activated] = p3.CloseCallback
			}),
			ContentWrapper = Roact.createElement("Frame", {
				BackgroundTransparency = 1,
				Size = UDim2.new(1, 0, 1, -v47),
				Position = UDim2.new(0, 0, 0, v47)
			}, p3.contents)
		})
	end
end
function v18.didMount(p4) -- line: 141
	-- upvalues: Otter (copy)
	p4.motor = Otter.createSingleMotor(p4.visibility)
	p4.motor:onStep(function(p5) -- line: 143
		-- upvalues: p4 (copy)
		p4.visibility = p5

		if p4.baseFrameRef.current then
			p4.baseFrameRef.current.Position = p4.getWidgetPosition()
			p4.baseFrameRef.current.Parent.BackgroundTransparency = 1 - 0.5 * p4.visibility
		end

		if p5 == 0 and p4.state.visible then
			p4:setState({
				visible = false
			})

			return
		end

		if p5 == 1 and not p4.state.fullLoad then
			p4:setState({
				fullLoad = true
			})
		end
	end)
end
function v18.willUnmount(p6) -- line: 162
	if p6.motor then
		p6.motor:destroy()
	end
end

v18.defaultProps = {
	SearchPlaceholder = "Feature.Chat.Label.SearchWord"
}

function v18.render(p7) -- line: 172
	-- upvalues: FormFactor (copy), withLocalization (copy), Roact (copy), AppFonts (copy), White (copy), SearchBar (copy), Obsidian (copy), Flint (copy), WindowedListFrame (copy)
	local v27 = p7.props.formFactor == FormFactor.WIDE
	local n1 = 27
	local n2 = 14
	local n3 = 24
	local n4 = 24
	local u32 = n2 + 36

	if v27 then
		n1 = 48
		n2 = 18
		n3 = 30
		n4 = 24
		u32 = n2 + 48
	end

	local v33 = n2 * 2.4
	local v34 = v33 + 40 + n4
	local v35 = p7.props.VisibilityTarget == 1

	return withLocalization({
		heading = p7.props.Heading,
		search = p7.props.SearchPlaceholder
	})(function(p8) -- line: 197
		-- upvalues: v35 (copy), Roact (copy), p7 (copy), v27 (copy), n1 (ref), n4 (ref), AppFonts (copy), White (copy), SearchBar (copy), v33 (copy), Obsidian (copy), Flint (copy), n3 (ref), n2 (ref), WindowedListFrame (copy), v34 (copy), u32 (ref)
		local v50 = nil

		if v35 then
			v50 = false
		end

		return Roact.createElement(not v35 and "Frame" or "TextButton", {
			BorderSizePixel = 0,
			AutoButtonColor = v50,
			Text = if not v35 then nil else "",
			BackgroundColor3 = Color3.new(0, 0, 0),
			BackgroundTransparency = 1 - 0.5 * p7.visibility,
			Size = UDim2.new(1, 0, 1, 0)
		}, { Roact.createElement(p7.renderWidgetBackground, {
			isWideScreen = v27,
			closeButtonSize = n1,
			Position = p7.getWidgetPosition(),
			CloseCallback = p7.props.CloseCallback,
			Visible = p7.state.visible,
			contents = {
				Heading = Roact.createElement("TextLabel", {
					BackgroundTransparency = 1,
					Text = p8.heading,
					Size = UDim2.new(1, 0, 0, n4),
					TextSize = n4,
					Font = AppFonts.default:getBold(),
					TextColor3 = White,
					TextXAlignment = Enum.TextXAlignment.Left
				}),
				SearchBar = Roact.createElement(SearchBar, {
					Text = "",
					Size = UDim2.new(1, 0, 0, v33),
					Position = UDim2.new(0, 0, 0, n4 + 20),
					ImageColor3 = Obsidian,
					PlaceholderText = p8.search,
					PlaceholderColor3 = Flint,
					IconSize = n3,
					TextSize = n2,
					TextColor3 = White,
					TextChanged = p7.searchTextChanged
				}),
				ListFrame = Roact.createElement(WindowedListFrame, {
					List = p7.state.filteredList,
					ScrollingFrameOffset = v34,
					TextSize = n2,
					ButtonSizeY = u32,
					ListButton = p7.props.ListButton,
					ListButtonProps = {
						TextSize = n2,
						SelectionCallback = p7.props.SelectionCallback
					}
				})
			}
		}) })
	end)
end
function v18.didUpdate(p9, p10) -- line: 255
	-- upvalues: Otter (copy)
	if p9.visibilityTarget ~= p9.props.VisibilityTarget and p9.motor then
		p9.visibilityTarget = p9.props.VisibilityTarget
		p9.motor:setGoal(Otter.spring(p9.visibilityTarget), {
			frequency = 3
		})

		if p9.visibilityTarget > 0 and not p9.state.visible then
			p9:setState({
				visible = true
			})
		end
	end

	if p10.List ~= p9.props.List or p9.props.VisibilityTarget == 1 and p10.VisibilityTarget ~= 1 then
		p9:setState({
			filteredList = p9.props.List
		})
	end
end

local v22 = RoactRodux.connect(function(p11, _) -- line: 277
	return {
		formFactor = p11.FormFactor
	}
end)(v18)

return RoactServices.connect({
	networking = RoactNetworking
})(v22)
