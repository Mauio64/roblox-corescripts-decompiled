local SocialLibraries = script:FindFirstAncestor("SocialLibraries")
local dependencies = require(SocialLibraries.dependencies)
local roact = dependencies.Roact
local cryo = dependencies.Cryo
local uiBlox = dependencies.UIBlox
local text = dependencies.Text
local foundationFontFaceMigration = dependencies.Foundation.Utility.Flags.FoundationFontFaceMigration
local getTextBoundsAsync = dependencies.Foundation.Utility.getTextBoundsAsync
local Components = SocialLibraries.Components
local AlertViewLabel = require(Components.AlertView.AlertViewLabel)
local AlertViewTextbox = require(Components.AlertView.AlertViewTextbox)
local AlertViewSoakArea = require(Components.AlertView.AlertViewSoakArea)
local FitFrameVertical = require(script.Parent.Parent.FitFrameVertical)
local interactiveAlert = uiBlox.App.Dialog.Alert.InteractiveAlert

local extended = roact.Component:extend("AlertViewBuilder")

extended.defaultProps = {
	bodyText = "",
	buttons = {},
	textboxes = {},
	displayTextbox = false,
	onActivated = function() end,
	onModalClose = function() end,
	onModalStayOpen = function() end,
	onModalOpen = function() end,
	title = "",
	childComponentWidth = 220,
	screenSize = Vector2.new(0, 0),
	soakAreaColor3 = Color3.fromRGB(255, 0, 255),
	soakAreaTransparency = 0.5,
	inputLengthExceeded = nil
}

function extended:init()
	self.refs = {}
	local count = 0

	for k, _ in pairs(self.props.textboxes) do
		self.refs[k] = roact.createRef()
		count += 1
	end

	self.state = { numTextboxes = count }

	if foundationFontFaceMigration then
		self.isMounted = false
		self.textMeasurements = {}

		function self.flushTextMeasurements()
			for k, textMeasurement in self.textMeasurements do
				if self.props.textboxes[k] then
					for k2, v in textMeasurement do
						if v.height ~= nil or v.inFlight then
							continue
						end

						v.inFlight = true
						local v2 = v
						local v3 = k2
						task.spawn(function()
							local textBoundsAsync = getTextBoundsAsync(v2.text, v2.font, v2.fontSize, v2.width)

							v2.inFlight = false

							local textMeasurement2 = self.textMeasurements[k]

							if
								textBoundsAsync
								and self.isMounted
								and textMeasurement2
								and textMeasurement2[v3] == v2
							then
								v2.height = textBoundsAsync.Y
								self:setState(function(p)
									return {
										textMeasurementVersion = (p.textMeasurementVersion or 0) + 1
									}
								end)
							end
						end)
					end
				else
					self.textMeasurements[k] = nil
				end
			end
		end

		function self.scheduleTextMeasurementFlush()
			if self.textMeasurementFlushScheduled then
				return
			end

			self.textMeasurementFlushScheduled = true
			task.defer(function()
				self.textMeasurementFlushScheduled = false

				if self.isMounted then
					self.flushTextMeasurements()
				end
			end)
		end
	end

	self.calcTextboxTextHeight = foundationFontFaceMigration and function(p, text2: string?, p2: string, p3: string)
		if text2 and text2 ~= "" then
			local fontSize = p.Font.Body.RelativeSize * p.Font.BaseSize
			local font = p.Font.Body.Font
			local childComponentWidth = self.props.childComponentWidth
			local v = self.textMeasurements[p2]

			if not v then
				v = {}
				self.textMeasurements[p2] = v
			end

			local v2 = v[p3]

			if
				v2
				and v2.text == text2
				and v2.font == font
				and v2.fontSize == fontSize
				and v2.width == childComponentWidth
			then
				if v2.height == nil then
					return fontSize
				end

				return v2.height
			end

			v[p3] = {
				text = text2,
				font = font,
				fontSize = fontSize,
				width = childComponentWidth,
				inFlight = false
			}

			self.scheduleTextMeasurementFlush()
			return fontSize
		else
			local textMeasurement = self.textMeasurements[p2]

			if textMeasurement then
				textMeasurement[p3] = nil
			end

			return 0
		end
	end or function(p, p2: string?)
		local v = p.Font.Body.RelativeSize * p.Font.BaseSize
		local font = p.Font.Body.Font

		return (not p2 or p2 == "") and 0 or text.GetTextHeight(p2, font, v, self.props.childComponentWidth)
	end
end

function extended:didMount()
	if foundationFontFaceMigration then
		self.isMounted = true
		self.flushTextMeasurements()
	end

	if type(self.props.onModalOpen) == "function" then
		self.props.onModalOpen()
	end
end

function extended.didUpdate(p)
	if foundationFontFaceMigration then
		p.flushTextMeasurements()
	end
end

function extended:willUnmount()
	if foundationFontFaceMigration then
		self.isMounted = false
	end
end

function extended:reset()
	for _, ref in pairs(self.refs) do
		if ref.current then
			ref.current.Text = ""
		end
	end
end

function extended:makeButtonTable()
	local buttonTable = { buttons = {} }

	for i, button in ipairs(self.props.buttons) do
		table.insert(buttonTable.buttons, {})
		local joined = cryo.Dictionary.join(button, {
			props = cryo.Dictionary.join(button.props, {
				layoutOrder = i,
				onActivated = function()
					self.props.onActivated()
					local texts = {}

					for k, ref in pairs(self.refs) do
						texts[k] = ref.current and ref.current.Text or ""
					end

					if button.props.onActivated(texts) then
						self.props.onModalStayOpen()

						return
					end

					self:reset()
					self:setState({ displayingModal = false })

					self.props.onModalClose()
				end
			})
		})

		buttonTable.buttons[i] = joined
	end

	return buttonTable
end

function extended:makeTextboxList(p)
	local children = {}

	local color = p.Theme.TextDefault.Color

	if self.props.inputLengthExceeded then
		color = p.Theme.Alert.Color
	end

	for k, textbox in pairs(self.props.textboxes) do
		local calcTextboxTextHeight = self.calcTextboxTextHeight(p, textbox.belowText, k, "belowText")
		local calcTextboxTextHeight2 = self.calcTextboxTextHeight(p, textbox.warningText, k, "warningText")

		local createElement = roact.createElement
		local v = {
			width = UDim.new(1, 0),
			BorderSizePixel = 0,
			BackgroundTransparency = 1,
			LayoutOrder = textbox.LayoutOrder
		}
		local children2 = {
			[k] = roact.createElement(AlertViewTextbox, {
				onTextChanged = textbox.onTextChanged,
				PlaceholderText = textbox.PlaceholderText,
				Text = textbox.Text,
				LayoutOrder = 1,
				[roact.Ref] = self.refs[k]
			})
		}

		local v2 = k .. " Below Text"
		local v3

		if textbox.belowText and textbox.belowText ~= "" then
			v3 = roact.createElement(AlertViewLabel, {
				BackgroundTransparency = 1,
				Text = textbox.belowText,
				LayoutOrder = 2,
				TextXAlignment = textbox.belowTextAlignment or Enum.TextXAlignment.Left,
				Size = UDim2.new(1, 0, 0, calcTextboxTextHeight),
				TextColor3 = color
			}) or nil
		end

		children2[v2] = v3

		local v4 = k .. " Warning Text"
		local v5

		if textbox.warningText and textbox.warningText ~= "" then
			v5 = roact.createElement(AlertViewLabel, {
				BackgroundTransparency = 1,
				Text = textbox.warningText,
				LayoutOrder = 3,
				TextXAlignment = Enum.TextXAlignment.Left,
				Size = UDim2.new(1, 0, 0, calcTextboxTextHeight2),
				TextColor3 = p.Theme.Alert.Color
			}) or nil
		end

		children2[v4] = v5
		children[k] = createElement(FitFrameVertical, v, children2)
	end

	return children
end

function extended:makeMiddleContent(p)
	local textboxList = self:makeTextboxList(p)

	if self.state.numTextboxes == 0 then
		return nil
	end

	return function()
		return roact.createElement(
			FitFrameVertical,
			{ width = UDim.new(1, 0), BorderSizePixel = 0, BackgroundTransparency = 1 },
			{
				Textboxes = roact.createElement(
					FitFrameVertical,
					{
						width = UDim.new(1, 0),
						BorderSizePixel = 0,
						BackgroundTransparency = 1,
						LayoutOrder = 1
					},
					textboxList
				)
			}
		)
	end
end

function extended:render()
	assert(self.props.displayTextbox or not self.props.mandatoryInput)

	return uiBlox.Style.withStyle(function(p)
		local buttonTable = self:makeButtonTable()
		local middleContent = self:makeMiddleContent(p)
		local bodyText

		if self.props.bodyText ~= "" then
			bodyText = self.props.bodyText or nil
		end

		return roact.createElement(
			AlertViewSoakArea,
			{
				BackgroundColor3 = self.props.soakAreaColor3,
				BackgroundTransparency = self.props.soakAreaTransparency,
				Visible = self.state.displayingModal
			},
			{
				alertView = roact.createElement(interactiveAlert, {
					title = self.props.title,
					bodyText = bodyText,
					middleContent = middleContent,
					buttonStackInfo = buttonTable,
					screenSize = self.props.screenSize
				})
			}
		)
	end)
end

return extended
