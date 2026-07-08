local CorePackages = game:GetService("CorePackages")
local Roact = require(CorePackages.Packages.Roact)
local Constants = require(script.Parent.Parent.Constants)
local FrameHeight = Constants.UtilityBarFormatting.FrameHeight
local SmallFrameHeight = Constants.UtilityBarFormatting.SmallFrameHeight
local ClientServerButtonWidth = Constants.UtilityBarFormatting.ClientServerButtonWidth
local ClientServerDropDownWidth = Constants.UtilityBarFormatting.ClientServerDropDownWidth
local UtilBar = Constants.Font.UtilBar
local UtilBar2 = Constants.DefaultFontSize.UtilBar
local ColorText = Constants.Color.Text
local FullScreenDropDownButton = require(script.Parent.FullScreenDropDownButton)
local DropDown = require(script.Parent.DropDown)
local uDim2 = UDim2.new(0, ClientServerButtonWidth, 0, FrameHeight)
local t1 = {
	"Client",
	"Server"
}
local v15 = Roact.Component:extend("ClientServerButton")

function v15.init(p1) -- line: 21
	function p1.dropDownCallback(p2) -- line: 22
		-- upvalues: p1 (copy)
		if p2 == 1 then
			p1.props.onClientButton()

			return
		end

		if p2 == 2 then
			p1.props.onServerButton()
		end
	end
end
function v15.render(p3) -- line: 31
	-- upvalues: Constants (copy), Roact (copy), FullScreenDropDownButton (copy), ClientServerDropDownWidth (copy), SmallFrameHeight (copy), t1 (copy), DropDown (copy), ClientServerButtonWidth (copy), FrameHeight (copy), UtilBar2 (copy), ColorText (copy), UtilBar (copy), uDim2 (copy)
	local formFactor = p3.props.formFactor
	local useDropDown = p3.props.useDropDown
	local isClientView = p3.props.isClientView
	local layoutOrder = p3.props.layoutOrder
	local onServerButton = p3.props.onServerButton
	local onClientButton = p3.props.onClientButton
	local SelectedBlue = Constants.Color.SelectedBlue
	local UnselectedGray = Constants.Color.UnselectedGray

	if isClientView then
		UnselectedGray = Constants.Color.SelectedBlue
		SelectedBlue = Constants.Color.UnselectedGray
	end

	if formFactor == Constants.FormFactor.Small then
		return Roact.createElement(FullScreenDropDownButton, {
			buttonSize = UDim2.new(0, ClientServerDropDownWidth, 0, SmallFrameHeight),
			dropDownList = t1,
			selectedIndex = not isClientView and 2 or 1,
			onSelection = p3.dropDownCallback,
			layoutOrder = layoutOrder
		})
	end

	if useDropDown then
		return Roact.createElement(DropDown, {
			buttonSize = UDim2.new(0, ClientServerDropDownWidth, 0, SmallFrameHeight),
			dropDownList = t1,
			selectedIndex = not isClientView and 2 or 1,
			onSelection = p3.dropDownCallback,
			layoutOrder = layoutOrder
		})
	end

	return Roact.createElement("Frame", {
		BackgroundTransparency = 1,
		Size = UDim2.new(0, 2 * ClientServerButtonWidth, 0, FrameHeight),
		LayoutOrder = layoutOrder
	}, {
		ClientButton = Roact.createElement("TextButton", {
			Text = t1[1],
			TextSize = UtilBar2,
			TextColor3 = ColorText,
			Font = UtilBar,
			Size = uDim2,
			AutoButtonColor = false,
			BackgroundColor3 = UnselectedGray,
			BackgroundTransparency = 0,
			LayoutOrder = 1,
			[Roact.Event.Activated] = onClientButton
		}),
		ServerButton = Roact.createElement("TextButton", {
			Text = t1[2],
			TextSize = UtilBar2,
			TextColor3 = ColorText,
			Font = UtilBar,
			Size = uDim2,
			AutoButtonColor = false,
			Position = UDim2.new(0, ClientServerButtonWidth, 0, 0),
			BackgroundColor3 = SelectedBlue,
			BackgroundTransparency = 0,
			LayoutOrder = 2,
			[Roact.Event.Activated] = onServerButton
		})
	})
end

return v15
