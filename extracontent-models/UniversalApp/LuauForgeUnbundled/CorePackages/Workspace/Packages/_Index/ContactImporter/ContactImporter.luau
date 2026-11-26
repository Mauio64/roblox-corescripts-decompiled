return {
	ContactImporterManager = require("@game/CorePackages/Workspace/Packages/_Index/ContactImporter/ContactImporter/ContactImporterManager"),
	Actions = require("@game/CorePackages/Workspace/Packages/_Index/ContactImporter/ContactImporter/Actions"),
	ContactsList = require("@game/CorePackages/Workspace/Packages/_Index/ContactImporter/ContactImporter/ContactsList/Components/ContactsList"),
	ContactsRevokedAccessDialog = require("@game/CorePackages/Workspace/Packages/_Index/ContactImporter/ContactImporter/ContactsList/Components/ContactsRevokedAccessDialog"),
	installReducer = require("@game/CorePackages/Workspace/Packages/_Index/ContactImporter/ContactImporter/installReducer"),
	ShowContactImporterParams = require("@game/CorePackages/Workspace/Packages/_Index/ContactImporter/ContactImporter/installReducer/ShowContactImporterParams"),
	FindFriendsModal = require("@game/CorePackages/Workspace/Packages/_Index/ContactImporter/ContactImporter/FindFriendsModal"),
	ContactImporterLandingPage = require("@game/CorePackages/Workspace/Packages/_Index/ContactImporter/ContactImporter/ContactImporterLandingPage"),
	Networking = require("@game/CorePackages/Workspace/Packages/_Index/ContactImporter/ContactImporter/Networking"),
	Signals = require("@game/CorePackages/Workspace/Packages/_Index/ContactImporter/ContactImporter/Signals"),
	RoduxKey = require("@game/CorePackages/Workspace/Packages/_Index/ContactImporter/ContactImporter/Common/Constants").RODUX_KEY,
	Constants = require("@game/CorePackages/Workspace/Packages/_Index/ContactImporter/ContactImporter/Common/Constants"),
	TextKeys = require("@game/CorePackages/Workspace/Packages/_Index/ContactImporter/ContactImporter/Common/TextKeys"),
	Utils = require("@game/CorePackages/Workspace/Packages/_Index/ContactImporter/ContactImporter/Utils"),
	Flags = require("@game/CorePackages/Workspace/Packages/_Index/ContactImporter/ContactImporter/Flags"),
	dependencies = require("@game/CorePackages/Workspace/Packages/_Index/ContactImporter/ContactImporter/dependencies"),
	useBeginContactImporter = require("@game/CorePackages/Workspace/Packages/_Index/ContactImporter/ContactImporter/Hooks/useBeginContactImporter")
}
