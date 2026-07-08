local ParentParent = script.Parent.Parent.Parent.Parent
local dependencies = require(ParentParent.dependencies)
local t = dependencies.t
local Roact = dependencies.Roact
local UIBlox = dependencies.UIBlox
local withLocalization = dependencies.withLocalization
local FullPageModal = UIBlox.App.Dialog.Modal.FullPageModal
local withStyle = UIBlox.Style.withStyle
local TextKeys = require(ParentParent.Common.TextKeys)
local ContactsGlimmer = require(ParentParent.ContactsList.Components.ContactsGlimmer)
local v11 = Roact.PureComponent:extend("ContactsListLoadingView")

v11.validateProps = t.strictInterface({
	screenSize = t.Vector2
})

function v11.render(p1) -- line: 29
	-- upvalues: withLocalization (copy), TextKeys (copy), withStyle (copy), Roact (copy), FullPageModal (copy), ContactsGlimmer (copy)
	local screenSize = p1.props.screenSize

	return withLocalization({
		titleText = TextKeys.CONTACTS_LIST_TITLE
	})(function(p2) -- line: 34
		-- upvalues: withStyle (copy), Roact (copy), FullPageModal (copy), screenSize (copy), ContactsGlimmer (copy)
		return withStyle(function(_) -- line: 35
			-- upvalues: Roact (copy), FullPageModal (copy), p2 (copy), screenSize (copy), ContactsGlimmer (copy)
			return Roact.createElement(FullPageModal, {
				title = p2.titleText,
				screenSize = screenSize
			}, {
				LoadingViewContainer = Roact.createElement("Frame", {
					BackgroundTransparency = 1,
					LayoutOrder = 1,
					AutomaticSize = Enum.AutomaticSize.Y,
					Size = UDim2.new(1, 0, 1, 0)
				}, {
					UIListLayout = Roact.createElement("UIListLayout", {
						FillDirection = Enum.FillDirection.Vertical,
						SortOrder = Enum.SortOrder.LayoutOrder,
						Padding = UDim.new(0, 12),
						HorizontalAlignment = Enum.HorizontalAlignment.Left
					}),
					UIPadding = Roact.createElement("UIPadding", {
						PaddingTop = UDim.new(0, 24),
						PaddingBottom = UDim.new(0, 36)
					}),
					Glimmer1 = Roact.createElement(ContactsGlimmer, {
						layoutOrder = 1
					}),
					Glimmer2 = Roact.createElement(ContactsGlimmer, {
						layoutOrder = 2
					}),
					Glimmer3 = Roact.createElement(ContactsGlimmer, {
						layoutOrder = 3
					})
				})
			})
		end)
	end)
end

return v11
