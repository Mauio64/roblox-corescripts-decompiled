local SocialLibraries = script:FindFirstAncestor("SocialLibraries")
local dependencies = require(SocialLibraries.dependencies)
local Roact = dependencies.Roact
local Cryo = dependencies.Cryo
local UIBlox = dependencies.UIBlox
local dependenciesText = dependencies.Text
local Components = SocialLibraries.Components
local AlertViewLabel = require(Components.AlertView.AlertViewLabel)
local AlertViewTextbox = require(Components.AlertView.AlertViewTextbox)
local AlertViewSoakArea = require(Components.AlertView.AlertViewSoakArea)
local FitFrameVertical = require(script.Parent.Parent.FitFrameVertical)
local InteractiveAlert = UIBlox.App.Dialog.Alert.InteractiveAlert
local v13 = Roact.Component:extend("AlertViewBuilder")

v13.defaultProps = {
	bodyText = "",
	displayTextbox = false,
	title = "",
	childComponentWidth = 220,
	soakAreaTransparency = 0.5,
	inputLengthExceeded = nil,
	buttons = {},
	textboxes = {},
	onActivated = function() -- line: 68
	end,
	onModalClose = function() -- line: 69
	end,
	onModalStayOpen = function() -- line: 70
	end,
	onModalOpen = function() -- line: 71
	end,
	screenSize = Vector2.new(0, 0),
	soakAreaColor3 = Color3.fromRGB(255, 0, 255)
}

function v13.init(p1) -- line: 83
	-- upvalues: Roact (copy), dependenciesText (copy)
	local n1 = 0

	p1.refs = {}

	for k, _ in pairs(p1.props.textboxes) do
		p1.refs[k] = Roact.createRef()
		n1 += 1
	end

	p1.state = {
		numTextboxes = n1
	}

	function p1.calcTextboxTextHeight(p2, p3) -- line: 93
		-- upvalues: dependenciesText (copy), p1 (copy)
		local v41 = p2.Font.Body.RelativeSize * p2.Font.BaseSize
		local BodyFont = p2.Font.Body.Font
		local n2 = 0

		if p3 and p3 ~= "" then
			n2 = dependenciesText.GetTextHeight(p3, BodyFont, v41, p1.props.childComponentWidth)
		end

		return n2
	end
end
function v13.didMount(p4) -- line: 105
	if type(p4.props.onModalOpen) == "function" then
		p4.props.onModalOpen()
	end
end
function v13.reset(p5) -- line: 111
	for _, v in pairs(p5.refs) do
		if v.current then
			v.current.Text = ""
		end
	end
end
function v13.makeButtonTable(p6) -- line: 119
	-- upvalues: Cryo (copy)
	local t1 = {
		buttons = {}
	}

	for i, v in ipairs(p6.props.buttons) do
		table.insert(t1.buttons, {})

		local v26 = Cryo.Dictionary.join(v, {
			props = Cryo.Dictionary.join(v.props, {
				layoutOrder = i,
				onActivated = function() -- line: 128
					-- upvalues: p6 (copy), v (copy)
					p6.props.onActivated()

					local t2 = {}

					for k, v2 in pairs(p6.refs) do
						t2[k] = v2.current and v2.current.Text or ""
					end

					if not v.props.onActivated(t2) then
						p6:reset()
						p6:setState({
							displayingModal = false
						})
						p6.props.onModalClose()

						return
					end

					p6.props.onModalStayOpen()
				end
			})
		})

		t1.buttons[i] = v26
	end

	return t1
end
function v13.makeTextboxList(p7, p8) -- line: 153
	-- upvalues: Roact (copy), FitFrameVertical (copy), AlertViewTextbox (copy), AlertViewLabel (copy)
	local t3 = {}
	local TextDefaultColor = p8.Theme.TextDefault.Color

	if p7.props.inputLengthExceeded then
		TextDefaultColor = p8.Theme.Alert.Color
	end

	for k, v in pairs(p7.props.textboxes) do
		local v33 = p7.calcTextboxTextHeight(p8, v.belowText)
		local v34 = p7.calcTextboxTextHeight(p8, v.warningText)

		t3[k] = Roact.createElement(FitFrameVertical, {
			BorderSizePixel = 0,
			BackgroundTransparency = 1,
			width = UDim.new(1, 0),
			LayoutOrder = v.LayoutOrder
		}, {
			[k] = Roact.createElement(AlertViewTextbox, {
				onTextChanged = v.onTextChanged,
				PlaceholderText = v.PlaceholderText,
				Text = v.Text,
				LayoutOrder = 1,
				[Roact.Ref] = p7.refs[k]
			}),
			[k .. " Below Text"] = v.belowText and (v.belowText ~= "" and Roact.createElement(AlertViewLabel, {
				BackgroundTransparency = 1,
				LayoutOrder = 2,
				Text = v.belowText,
				TextXAlignment = v.belowTextAlignment or Enum.TextXAlignment.Left,
				Size = UDim2.new(1, 0, 0, v33),
				TextColor3 = TextDefaultColor
			})) or nil,
			[k .. " Warning Text"] = v.warningText and (v.warningText ~= "" and Roact.createElement(AlertViewLabel, {
				BackgroundTransparency = 1,
				LayoutOrder = 3,
				Text = v.warningText,
				TextXAlignment = Enum.TextXAlignment.Left,
				Size = UDim2.new(1, 0, 0, v34),
				TextColor3 = p8.Theme.Alert.Color
			})) or nil
		})
	end

	return t3
end
function v13.makeMiddleContent(p9, p10) -- line: 206
	-- upvalues: Roact (copy), FitFrameVertical (copy)
	local v37 = p9:makeTextboxList(p10)

	if p9.state.numTextboxes == 0 then
		return nil
	end

	return function() -- line: 215
		-- upvalues: Roact (copy), FitFrameVertical (copy), v37 (copy)
		return Roact.createElement(FitFrameVertical, {
			BorderSizePixel = 0,
			BackgroundTransparency = 1,
			width = UDim.new(1, 0)
		}, {
			Textboxes = Roact.createElement(FitFrameVertical, {
				BorderSizePixel = 0,
				BackgroundTransparency = 1,
				LayoutOrder = 1,
				width = UDim.new(1, 0)
			}, v37)
		})
	end
end
function v13.render(p11) -- line: 231
	-- upvalues: UIBlox (copy), Roact (copy), AlertViewSoakArea (copy), InteractiveAlert (copy)
	assert(p11.props.displayTextbox or not p11.props.mandatoryInput)

	return UIBlox.Style.withStyle(function(p12) -- line: 234
		-- upvalues: p11 (copy), Roact (copy), AlertViewSoakArea (copy), InteractiveAlert (copy)
		local v48 = p11:makeButtonTable()
		local v49 = p11:makeMiddleContent(p12)
		local v50 = p11.props.bodyText ~= "" and p11.props.bodyText or nil

		return Roact.createElement(AlertViewSoakArea, {
			BackgroundColor3 = p11.props.soakAreaColor3,
			BackgroundTransparency = p11.props.soakAreaTransparency,
			Visible = p11.state.displayingModal
		}, {
			alertView = Roact.createElement(InteractiveAlert, {
				title = p11.props.title,
				bodyText = v50,
				middleContent = v49,
				buttonStackInfo = v48,
				screenSize = p11.props.screenSize
			})
		})
	end)
end

return v13
