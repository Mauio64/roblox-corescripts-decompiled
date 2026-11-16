local CorePackages = game:GetService("CorePackages")
local TextService = game:GetService("TextService")
local Roact = require(CorePackages.Packages.Roact)

local Constants = require(script.Parent.Parent.Constants)
local FrameHeight = Constants.TabRowFormatting.FrameHeight
local TabDropDownWidth = Constants.TabRowFormatting.TabDropDownWidth
local TabOverlapThreshold = Constants.TabRowFormatting.TabOverlapThreshold

local frameHeight = Constants.UtilityBarFormatting.FrameHeight
local SmallFrameHeight = Constants.UtilityBarFormatting.SmallFrameHeight
local SmallUtilPadding = Constants.UtilityBarFormatting.SmallUtilPadding
local ClientServerButtonWidth = Constants.UtilityBarFormatting.ClientServerButtonWidth
local ClientServerDropDownWidth = Constants.UtilityBarFormatting.ClientServerDropDownWidth

local MainRowPadding = Constants.GeneralFormatting.MainRowPadding

local parent = script.Parent
local ClientServerButton = require(parent.ClientServerButton)
local CheckboxContainer = require(parent.CheckboxContainer)
local TabRowContainer = require(parent.TabRowContainer)
local SearchBar = require(parent.SearchBar)
local GetFFlagVoiceDebugConsoleV2 = require(parent.VoiceDebug.GetFFlagVoiceDebugConsoleV2)

local extended = Roact.Component:extend("UtilAndTab")

function extended:init()
	local tabList = self.props.tabList
	local total = 0
	local count = 0

	for k, _ in pairs(tabList) do
		total += TextService:GetTextSize(k, Constants.DefaultFontSize.TabBar, Constants.Font.TabBar, Vector2.new(0, 0)).X
		count += 1
	end

	function self.showSearchBar()
		self:setState({ activeSearchTerm = true })
	end

	function self.cancelInput(_, p)
		if
			p.UserInputType == Enum.UserInputType.MouseButton1
			or p.UserInputType == Enum.UserInputType.Touch and p.UserInputState == Enum.UserInputState.End
		then
			if self.searchRef.current then
				self.searchRef.current.Text = ""
			end

			local onSearchTermChanged = self.props.onSearchTermChanged

			if onSearchTermChanged then
				onSearchTermChanged("")
			end

			self:setState({ activeSearchTerm = false })
		end
	end

	function self.focusLost(p, p2, _)
		if p2 then
			local text = p.text
			local onSearchTermChanged = self.props.onSearchTermChanged

			if onSearchTermChanged then
				onSearchTermChanged(text)
			end

			local activeSearchTerm = text ~= ""

			if self.state.activeSearchTerm ~= activeSearchTerm then
				self:setState({ activeSearchTerm = activeSearchTerm })
			end
		end
	end

	self.state = { totalTabWidth = total, totalTabCount = count, activeSearchTerm = false }

	self.utilRef = Roact.createRef()
	self.searchRef = Roact.createRef()
end

function extended.render(props)
	local windowWidth = props.props.windowWidth
	local formFactor = props.props.formFactor
	local tabList = props.props.tabList
	local orderedCheckboxState = props.props.orderedCheckboxState
	local layoutOrder = props.props.layoutOrder
	local isClientView = props.props.isClientView
	local searchTerm = props.props.searchTerm

	local onClientButton = props.props.onClientButton
	local onServerButton = props.props.onServerButton
	local onCheckboxChanged = props.props.onCheckboxChanged
	local onSearchTermChanged = props.props.onSearchTermChanged

	local totalTabWidth = props.state.totalTabWidth
	local totalTabCount = props.state.totalTabCount
	local activeSearchTerm = props.state.activeSearchTerm
	local useDropDown

	if (windowWidth - totalTabWidth) / totalTabCount < TabOverlapThreshold then
		useDropDown = windowWidth > 0
	else
		useDropDown = false
	end

	local v = formFactor == Constants.FormFactor.Small and SmallFrameHeight or frameHeight
	local v2 = formFactor == Constants.FormFactor.Small and 6 or 7
	local v3 = props.props[Roact.Children] and math.ceil(#props.props[Roact.Children] / 5) or 1

	local element = Roact.createElement("Frame", {
		Position = UDim2.new(1, -v2 * ClientServerButtonWidth - MainRowPadding, 0, 0),
		Size = UDim2.new(0, 5 * ClientServerButtonWidth, 0, v * v3),
		BackgroundTransparency = 1
	}, {
		Layout = Roact.createElement("UIGridLayout", {
			CellPadding = UDim2.new(0, MainRowPadding, 0, 0),
			CellSize = UDim2.new(0, ClientServerButtonWidth, 0, v),
			SortOrder = Enum.SortOrder.LayoutOrder,
			HorizontalAlignment = Enum.HorizontalAlignment.Right,
			VerticalAlignment = Enum.VerticalAlignment.Top,
			FillDirectionMaxCells = 5
		}),
		unpack(props.props[Roact.Children] or {})
	})

	if formFactor == Constants.FormFactor.Small or useDropDown then
		local v4 = SmallFrameHeight * v3 + SmallUtilPadding

		if activeSearchTerm then
			v4 = v4 + SmallFrameHeight + SmallUtilPadding
		end

		local v5 = onClientButton and onServerButton

		local frameWidth = windowWidth - SmallFrameHeight - TabDropDownWidth

		if v5 then
			frameWidth -= ClientServerDropDownWidth
		end

		local v6 = TextService:GetTextSize(
			"Cancel",
			Constants.DefaultFontSize.UtilBar,
			Constants.Font.UtilBar,
			Vector2.new(0, 0)
		).X + 12

		local createElement = Roact.createElement
		local refForParentsByRef = {
			Size = UDim2.new(1, 0, 0, v4),
			BackgroundTransparency = 1,
			LayoutOrder = layoutOrder,
			[Roact.Ref] = props.props.refForParent
		}

		local createElement2 = Roact.createElement
		local utilRefsByRef = {
			Size = UDim2.new(1, 0, 0, SmallFrameHeight),
			BackgroundTransparency = 1,
			[Roact.Ref] = props.utilRef
		}
		local v7 = {
			MainRow = Roact.createElement("Frame", {
				Size = UDim2.new(1, 0, 1, 0),
				BackgroundTransparency = 1
			}, {
				UIListLayout = Roact.createElement("UIListLayout", {
					HorizontalAlignment = Enum.HorizontalAlignment.Left,
					SortOrder = Enum.SortOrder.LayoutOrder,
					VerticalAlignment = Enum.VerticalAlignment.Top,
					FillDirection = Enum.FillDirection.Horizontal,
					Padding = UDim.new(0, SmallUtilPadding)
				}),
				Tabs = Roact.createElement(TabRowContainer, {
					tabList = tabList,
					windowWidth = windowWidth,
					frameHeight = SmallFrameHeight,
					formFactor = formFactor,
					layoutOrder = 1
				}),
				ClientServerButton = v5 and Roact.createElement(ClientServerButton, {
					frameHeight = SmallFrameHeight,
					formFactor = formFactor,
					useDropDown = useDropDown,
					isClientView = isClientView,
					layoutOrder = 2,
					onClientButton = onClientButton,
					onServerButton = onServerButton
				}),
				FilterCheckboxes = onCheckboxChanged and Roact.createElement(CheckboxContainer, {
					orderedCheckboxState = orderedCheckboxState,
					frameWidth = frameWidth,
					frameHeight = SmallFrameHeight,
					pos = UDim2.new(0, 2 * ClientServerButtonWidth + MainRowPadding, 0, 0),
					layoutOrder = 3,
					onCheckboxChanged = onCheckboxChanged
				})
			}),
			SearchButton = Roact.createElement("ImageButton", {
				Size = UDim2.new(0, SmallFrameHeight, 0, SmallFrameHeight),
				Position = UDim2.new(1, -SmallFrameHeight, 0, 0),
				BackgroundTransparency = 1,
				Image = Constants.Image.Search,
				Visible = not activeSearchTerm,
				[Roact.Event.Activated] = props.showSearchBar
			}),
			Buttons = element,
			ExtraContent = 0
		}
		local extraContent

		if GetFFlagVoiceDebugConsoleV2() then
			extraContent = props.props.extraContent
		end

		v7.ExtraContent = extraContent
		return createElement("Frame", refForParentsByRef, {
			MainFrame = createElement2("Frame", utilRefsByRef, v7),
			SearchBarFrame = Roact.createElement("Frame", {
				Size = UDim2.new(1, 0, 0, SmallFrameHeight),
				Position = UDim2.new(0, 0, 0, (SmallFrameHeight + SmallUtilPadding) * v3),
				Visible = activeSearchTerm,
				BorderSizePixel = 0,
				BackgroundTransparency = 1
			}, {
				SearchBar = Roact.createElement(SearchBar, {
					size = UDim2.new(1, -v6, 0, SmallFrameHeight),
					searchTerm = searchTerm,
					showClear = activeSearchTerm,
					textSize = Constants.DefaultFontSize.Search,
					font = Constants.Font.Search,
					frameHeight = SmallFrameHeight,
					refForParent = props.searchRef,
					cancelInput = props.cancelInput,
					focusLost = props.focusLost
				}),
				CancelButton = Roact.createElement("TextButton", {
					Size = UDim2.new(0, v6, 1, 0),
					Position = UDim2.new(1, -v6, 0, 0),
					Text = "Cancel",
					TextSize = Constants.DefaultFontSize.UtilBar,
					TextColor3 = Constants.Color.Text,
					Font = Constants.Font.UtilBar,
					BorderSizePixel = 0,
					BackgroundTransparency = 1,
					[Roact.Event.Activated] = props.cancelInput
				})
			})
		})
	else
		local v4 = onClientButton and onServerButton

		local frameWidth = windowWidth - SmallUtilPadding * 3 - 3 * ClientServerButtonWidth

		if v4 then
			frameWidth -= ClientServerButtonWidth
		end

		local createElement = Roact.createElement
		local refForParentsByRef = {
			Size = UDim2.new(1, 0, 0, FrameHeight + frameHeight * v3 + MainRowPadding),
			BackgroundTransparency = 1,
			LayoutOrder = layoutOrder,
			[Roact.Ref] = props.props.refForParent
		}
		local v5 = {
			Tabs = Roact.createElement(TabRowContainer, {
				tabList = tabList,
				windowWidth = windowWidth,
				frameHeight = FrameHeight,
				formFactor = formFactor
			}),
			UtilBar = 0
		}

		local createElement2 = Roact.createElement
		local utilRefsByRef = {
			Position = UDim2.new(0, 4, 0, FrameHeight + MainRowPadding),
			Size = UDim2.new(1, -8, 0, frameHeight),
			BackgroundTransparency = 1,
			[Roact.Ref] = props.utilRef
		}
		local v6 = {
			MainRow = Roact.createElement("Frame", {
				Size = UDim2.new(1, 0, 1, 0),
				BackgroundTransparency = 1
			}, {
				UIListLayout = Roact.createElement("UIListLayout", {
					HorizontalAlignment = Enum.HorizontalAlignment.Left,
					SortOrder = Enum.SortOrder.LayoutOrder,
					VerticalAlignment = Enum.VerticalAlignment.Top,
					FillDirection = Enum.FillDirection.Horizontal,
					Padding = UDim.new(0, SmallUtilPadding)
				}),
				ClientServerButton = v4 and Roact.createElement(ClientServerButton, {
					formFactor = formFactor,
					isClientView = isClientView,
					onClientButton = onClientButton,
					onServerButton = onServerButton
				}),
				FilterCheckboxes = onCheckboxChanged and Roact.createElement(CheckboxContainer, {
					orderedCheckboxState = orderedCheckboxState,
					frameWidth = frameWidth,
					frameHeight = frameHeight,
					pos = UDim2.new(0, 2 * ClientServerButtonWidth + MainRowPadding, 0, 0),
					onCheckboxChanged = onCheckboxChanged
				})
			}),
			SearchBar = onSearchTermChanged and Roact.createElement(SearchBar, {
				size = UDim2.new(0, 2 * ClientServerButtonWidth, 0, frameHeight),
				pos = UDim2.new(1, -2 * ClientServerButtonWidth, 0, 0),
				searchTerm = searchTerm,
				showClear = activeSearchTerm,
				textSize = Constants.DefaultFontSize.Search,
				font = Constants.Font.Search,
				frameHeight = Constants.UtilityBarFormatting.FrameHeight,
				refForParent = props.searchRef,
				cancelInput = props.cancelInput,
				focusLost = props.focusLost
			}),
			Buttons = element,
			ExtraContent = 0
		}
		local extraContent

		if GetFFlagVoiceDebugConsoleV2() then
			extraContent = props.props.extraContent
		end

		v6.ExtraContent = extraContent
		v5.UtilBar = createElement2("Frame", utilRefsByRef, v6)
		return createElement("Frame", refForParentsByRef, v5)
	end
end

return extended
