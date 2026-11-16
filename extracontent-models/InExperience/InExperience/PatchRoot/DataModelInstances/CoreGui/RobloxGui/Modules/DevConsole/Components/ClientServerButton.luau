local CorePackages = game:GetService("CorePackages")
local Roact = require(CorePackages.Packages.Roact)

local Constants = require(script.Parent.Parent.Constants)
local FrameHeight = Constants.UtilityBarFormatting.FrameHeight
local SmallFrameHeight = Constants.UtilityBarFormatting.SmallFrameHeight
local ClientServerButtonWidth = Constants.UtilityBarFormatting.ClientServerButtonWidth
local ClientServerDropDownWidth = Constants.UtilityBarFormatting.ClientServerDropDownWidth
local UtilBar = Constants.Font.UtilBar
local utilBar = Constants.DefaultFontSize.UtilBar
local Text = Constants.Color.Text

local FullScreenDropDownButton = require(script.Parent.FullScreenDropDownButton)
local DropDown = require(script.Parent.DropDown)

local udim = UDim2.new(0, ClientServerButtonWidth, 0, FrameHeight)
local dropDownList = { "Client", "Server" }

local extended = Roact.Component:extend("ClientServerButton")

function extended:init()
	function self.dropDownCallback(p)
		if p == 1 then
			self.props.onClientButton()
		elseif p == 2 then
			self.props.onServerButton()
		end
	end
end

function extended.render(p)
	local formFactor = p.props.formFactor
	local useDropDown = p.props.useDropDown
	local isClientView = p.props.isClientView
	local layoutOrder = p.props.layoutOrder
	local onServerButton = p.props.onServerButton
	local onClientButton = p.props.onClientButton

	local backgroundColor = Constants.Color.SelectedBlue
	local backgroundColor2 = Constants.Color.UnselectedGray

	if isClientView then
		backgroundColor2 = Constants.Color.SelectedBlue
		backgroundColor = Constants.Color.UnselectedGray
	end

	if formFactor == Constants.FormFactor.Small then
		return Roact.createElement(FullScreenDropDownButton, {
			buttonSize = UDim2.new(0, ClientServerDropDownWidth, 0, SmallFrameHeight),
			dropDownList = dropDownList,
			selectedIndex = isClientView and 1 or 2,
			onSelection = p.dropDownCallback,
			layoutOrder = layoutOrder
		})
	end

	if useDropDown then
		return Roact.createElement(DropDown, {
			buttonSize = UDim2.new(0, ClientServerDropDownWidth, 0, SmallFrameHeight),
			dropDownList = dropDownList,
			selectedIndex = isClientView and 1 or 2,
			onSelection = p.dropDownCallback,
			layoutOrder = layoutOrder
		})
	end

	return Roact.createElement("Frame", {
		Size = UDim2.new(0, 2 * ClientServerButtonWidth, 0, FrameHeight),
		BackgroundTransparency = 1,
		LayoutOrder = layoutOrder
	}, {
		ClientButton = Roact.createElement("TextButton", {
			Text = dropDownList[1],
			TextSize = utilBar,
			TextColor3 = Text,
			Font = UtilBar,
			Size = udim,
			AutoButtonColor = false,
			BackgroundColor3 = backgroundColor2,
			BackgroundTransparency = 0,
			LayoutOrder = 1,
			[Roact.Event.Activated] = onClientButton
		}),
		ServerButton = Roact.createElement("TextButton", {
			Text = dropDownList[2],
			TextSize = utilBar,
			TextColor3 = Text,
			Font = UtilBar,
			Size = udim,
			AutoButtonColor = false,
			Position = UDim2.new(0, ClientServerButtonWidth, 0, 0),
			BackgroundColor3 = backgroundColor,
			BackgroundTransparency = 0,
			LayoutOrder = 2,
			[Roact.Event.Activated] = onServerButton
		})
	})
end

return extended
