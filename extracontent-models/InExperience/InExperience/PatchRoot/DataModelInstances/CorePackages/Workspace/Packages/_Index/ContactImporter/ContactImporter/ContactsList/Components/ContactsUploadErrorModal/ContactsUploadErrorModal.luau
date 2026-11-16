local parent = script.Parent.Parent.Parent.Parent
local dependencies = require(parent.dependencies)

local roact = dependencies.Roact
local uiBlox = dependencies.UIBlox
local withLocalization = dependencies.withLocalization

local images = uiBlox.App.ImageSet.Images
local TextKeys = require(parent.Common.TextKeys)
local ContactsInformationModal = require(parent.ContactsList.Components.ContactsInformationModal)

local extended = roact.PureComponent:extend("ContactsUploadErrorModal")

function extended.render(_)
	return withLocalization({ hasUploadError = TextKeys.UPLOAD_CONTACTS_FAILURE })(function(p)
		return roact.createElement(ContactsInformationModal, {
			image = images["icons/status/error_large"],
			text = p.hasUploadError
		})
	end)
end

return extended
