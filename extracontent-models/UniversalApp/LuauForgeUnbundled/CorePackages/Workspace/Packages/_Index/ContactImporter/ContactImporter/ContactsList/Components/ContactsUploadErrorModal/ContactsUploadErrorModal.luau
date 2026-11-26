local dependencies = require("@game/CorePackages/Workspace/Packages/_Index/ContactImporter/ContactImporter/dependencies")

local roact = dependencies.Roact
local uiBlox = dependencies.UIBlox
local withLocalization = dependencies.withLocalization

local images = uiBlox.App.ImageSet.Images
local TextKeys = require("@game/CorePackages/Workspace/Packages/_Index/ContactImporter/ContactImporter/Common/TextKeys")
local ContactsInformationModal = require("@game/CorePackages/Workspace/Packages/_Index/ContactImporter/ContactImporter/ContactsList/Components/ContactsInformationModal")

local extended = roact.PureComponent:extend("ContactsUploadErrorModal")

function extended.render(p2)
	return withLocalization({ hasUploadError = TextKeys.UPLOAD_CONTACTS_FAILURE })(function(p3)
		return roact.createElement(ContactsInformationModal, {
			image = images["icons/status/error_large"],
			text = p3.hasUploadError
		})
	end)
end

return extended
