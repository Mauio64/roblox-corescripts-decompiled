local parent = script.Parent.Parent.Parent.Parent
local dependencies = require(parent.dependencies)

local t = dependencies.t
local roact = dependencies.Roact
local uiBlox = dependencies.UIBlox
local withLocalization = dependencies.withLocalization

local fullPageModal = uiBlox.App.Dialog.Modal.FullPageModal
local withStyle = uiBlox.Style.withStyle

local TextKeys = require(parent.Common.TextKeys)
local ContactsGlimmer = require(parent.ContactsList.Components.ContactsGlimmer)

local extended = roact.PureComponent:extend("ContactsListLoadingView")

extended.validateProps = t.strictInterface({ screenSize = t.Vector2 })

function extended.render(p)
	local screenSize = p.props.screenSize
	return withLocalization({ titleText = TextKeys.CONTACTS_LIST_TITLE })(function(p2)
		return withStyle(function(_)
			return roact.createElement(fullPageModal, {
				title = p2.titleText,
				screenSize = screenSize
			}, {
				LoadingViewContainer = roact.createElement(
					"Frame",
					{
						AutomaticSize = Enum.AutomaticSize.Y,
						Size = UDim2.new(1, 0, 1, 0),
						BackgroundTransparency = 1,
						LayoutOrder = 1
					},
					{
						UIListLayout = roact.createElement("UIListLayout", {
							FillDirection = Enum.FillDirection.Vertical,
							SortOrder = Enum.SortOrder.LayoutOrder,
							Padding = UDim.new(0, 12),
							HorizontalAlignment = Enum.HorizontalAlignment.Left
						}),
						UIPadding = roact.createElement("UIPadding", {
							PaddingTop = UDim.new(0, 24),
							PaddingBottom = UDim.new(0, 36)
						}),
						Glimmer1 = roact.createElement(ContactsGlimmer, { layoutOrder = 1 }),
						Glimmer2 = roact.createElement(ContactsGlimmer, { layoutOrder = 2 }),
						Glimmer3 = roact.createElement(ContactsGlimmer, { layoutOrder = 3 })
					}
				)
			})
		end)
	end)
end

return extended
