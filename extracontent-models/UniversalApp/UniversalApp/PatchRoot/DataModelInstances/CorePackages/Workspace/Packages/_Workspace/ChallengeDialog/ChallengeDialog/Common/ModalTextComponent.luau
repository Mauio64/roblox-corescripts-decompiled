local ChallengeDialog = script:FindFirstAncestor("ChallengeDialog")
local ChallengeDialogParent = ChallengeDialog.Parent
local React = require(ChallengeDialogParent.React)
local UIBlox = require(ChallengeDialogParent.UIBlox)
local LuaSocialLibrariesDeps = require(ChallengeDialogParent.LuaSocialLibrariesDeps)
local ModalTextSizes = require(ChallengeDialog.Common.ModalTextSizes)
local FitTextLabel = LuaSocialLibrariesDeps.RoactFitComponents.FitTextLabel
local withStyle = UIBlox.Style.withStyle

return function(t1: {[any]: any}) -- line: 25
	-- upvalues: withStyle (copy), ModalTextSizes (copy), React (copy), FitTextLabel (copy)
	local contentWidth = t1.contentWidth
	local layoutOrder = t1.layoutOrder
	local richText = t1.richText
	local text = t1.text

	return withStyle(function(p1) -- line: 31
		-- upvalues: t1 (copy), ModalTextSizes (copy), contentWidth (copy), React (copy), FitTextLabel (copy), layoutOrder (copy), richText (copy), text (copy)
		local BodyFont = p1.Font.Body.Font

		if t1.useBold == true then
			BodyFont = p1.Font.Header1.Font
		end

		local TextDefaultColor = p1.Theme.TextDefault.Color

		if t1.useEmphasis == true then
			TextDefaultColor = p1.Theme.TextEmphasis.Color
		end

		local RelativeSize = p1.Font.Body.RelativeSize

		if t1.size == ModalTextSizes.Header1 then
			RelativeSize = p1.Font.Header1.RelativeSize
		elseif t1.size == ModalTextSizes.Footer then
			RelativeSize = p1.Font.Footer.RelativeSize
		end

		local Center = Enum.TextXAlignment.Center

		if t1.alignLeft == true then
			Center = Enum.TextXAlignment.Left
		end

		local AutomaticSizeX = nil

		if contentWidth == 0 or contentWidth == nil then
			AutomaticSizeX = Enum.AutomaticSize.X
		end

		return React.createElement(FitTextLabel, {
			BackgroundTransparency = 1,
			TextWrapped = true,
			width = FitTextLabel.Width.FitToText,
			maximumWidth = contentWidth,
			Font = BodyFont,
			LayoutOrder = layoutOrder or nil,
			RichText = richText,
			AutomaticSize = AutomaticSizeX,
			Text = text,
			TextColor3 = TextDefaultColor,
			TextSize = RelativeSize * p1.Font.BaseSize,
			TextTransparency = p1.Theme.TextDefault.Transparency,
			TextXAlignment = Center,
			AnchorPoint = Vector2.new(0, 0),
			onActivated = t1.onActivated
		})
	end)
end
