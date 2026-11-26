local module = require("@game/CorePackages/Workspace/Packages/_Index/Gifting/Gifting/Components/GiftAccept/GiftAcceptView")
local module2 = require("@game/CorePackages/Workspace/Packages/_Index/Gifting/Gifting/Components/GiftAgeCheck/GiftAgeCheckContainer")
local module3 = require("@game/CorePackages/Workspace/Packages/_Index/Gifting/Gifting/Components/GiftAllowance/GiftAllowanceView")
local module4 = require("@game/CorePackages/Workspace/Packages/_Index/Gifting/Gifting/Components/GiftIconButton/GiftIconButtonView")
local module5 = require("@game/CorePackages/Workspace/Packages/_Index/Gifting/Gifting/Components/GiftSend/GiftSendView")
local module6 = require("@game/CorePackages/Workspace/Packages/_Index/Gifting/Gifting/Components/GiftRobuxBreakdown/GiftRobuxBreakdownView")
local module7 = require("@game/CorePackages/Workspace/Packages/_Index/Gifting/Gifting/Components/GiftSheetLayout/GiftSheetLayoutView")
local GiftStateEnum = require("@game/CorePackages/Workspace/Packages/_Index/Gifting/Gifting/Components/GiftState/GiftStateEnum")
local module9 = require("@game/CorePackages/Workspace/Packages/_Index/Gifting/Gifting/Components/GiftState/GiftStateView")
local module10 = require("@game/CorePackages/Workspace/Packages/_Index/Gifting/Gifting/Components/InfoTooltip/InfoTooltip")
local module11 = require("@game/CorePackages/Workspace/Packages/_Index/Gifting/Gifting/Components/RecipientPicker/RecipientPickerView")
local module12 = require("@game/CorePackages/Workspace/Packages/_Index/Gifting/Gifting/Components/GiftRejectConfirmation/GiftRejectConfirmationView")
require("@game/CorePackages/Workspace/Packages/_Index/Gifting/Gifting/Types")
local module13 = require("@game/CorePackages/Workspace/Packages/_Index/Gifting/Gifting/Components/UserInfoPanel/UserInfoPanelView")
local module14 = require("@game/CorePackages/Workspace/Packages/_Index/Gifting/Gifting/Utils/getFriendDuration")

require("@game/CorePackages/Workspace/Packages/_Index/Gifting/Gifting/Models/CanGiftResponseModel")
require("@game/CorePackages/Workspace/Packages/_Index/Gifting/Gifting/Models/GiftErrorModel")
require("@game/CorePackages/Workspace/Packages/_Index/Gifting/Gifting/Models/FindRecipientsResponseModel")
require("@game/CorePackages/Workspace/Packages/_Index/Gifting/Gifting/Models/PendingGiftsResponseModel")
require("@game/CorePackages/Workspace/Packages/_Index/Gifting/Gifting/Models/PrepareGiftResponseModel")
require("@game/CorePackages/Workspace/Packages/_Index/Gifting/Gifting/Models/ReceiverPreviewResponseModel")

local module15 = require("@game/CorePackages/Workspace/Packages/_Index/Gifting/Gifting/WebApi/postAcceptGift")
local module16 = require("@game/CorePackages/Workspace/Packages/_Index/Gifting/Gifting/WebApi/postPurchaseGift")
local module17 = require("@game/CorePackages/Workspace/Packages/_Index/Gifting/Gifting/WebApi/postRejectGift")

require("@game/CorePackages/Workspace/Packages/_Index/Gifting/Gifting/Stores/createCanGiftStore")

local module18 = require("@game/CorePackages/Workspace/Packages/_Index/Gifting/Gifting/Hooks/useGiftEligibility")
local module19 = require("@game/CorePackages/Workspace/Packages/_Index/Gifting/Gifting/Hooks/useGiftRecipients")

return {
	Components = {
		GiftAcceptView = module,
		GiftAgeCheckContainer = module2,
		GiftAllowanceView = module3,
		GiftIconButtonView = module4,
		GiftSendView = module5,
		GiftRobuxBreakdownView = module6,
		GiftSheetLayoutView = module7,
		GiftStateView = module9,
		InfoTooltip = module10,
		RecipientPickerView = module11,
		GiftRejectConfirmationView = module12,
		UserInfoPanelView = module13
	},
	Constants = require("@game/CorePackages/Workspace/Packages/_Index/Gifting/Gifting/Constants"),
	Hooks = { useGiftEligibility = module18, useGiftRecipients = module19 },
	Utils = { getFriendDuration = module14 },
	Flags = {},
	Enums = {
		GiftState = GiftStateEnum,
		ItemType = require("@game/CorePackages/Workspace/Packages/_Index/Gifting/Gifting/Enums/ItemType"),
		GiftEligibility = require("@game/CorePackages/Workspace/Packages/_Index/Gifting/Gifting/Enums/GiftEligibility"),
		RequiredAction = require("@game/CorePackages/Workspace/Packages/_Index/Gifting/Gifting/Enums/RequiredAction"),
		UserRelationship = require("@game/CorePackages/Workspace/Packages/_Index/Gifting/Gifting/Enums/UserRelationship"),
		FailureReason = require("@game/CorePackages/Workspace/Packages/_Index/Gifting/Gifting/Enums/FailureReason"),
		AmpRecourseAction = require("@game/CorePackages/Workspace/Packages/_Index/Gifting/Gifting/Enums/AmpRecourseAction")
	},
	WebApi = {
		Urls = require("@game/CorePackages/Workspace/Packages/_Index/Gifting/Gifting/WebApi/Urls"),
		postCanGift = require("@game/CorePackages/Workspace/Packages/_Index/Gifting/Gifting/WebApi/postCanGift"),
		postFindRecipients = require("@game/CorePackages/Workspace/Packages/_Index/Gifting/Gifting/WebApi/postFindRecipients"),
		postPrepareGift = require("@game/CorePackages/Workspace/Packages/_Index/Gifting/Gifting/WebApi/postPrepareGift"),
		postPurchaseGift = module16,
		postAcceptGift = module15,
		postRejectGift = module17,
		getPendingGifts = require("@game/CorePackages/Workspace/Packages/_Index/Gifting/Gifting/WebApi/getPendingGifts"),
		getReceiverPreview = require("@game/CorePackages/Workspace/Packages/_Index/Gifting/Gifting/WebApi/getReceiverPreview")
	},
	Stores = { getCanGiftStore = require("@game/CorePackages/Workspace/Packages/_Index/Gifting/Gifting/Stores/getCanGiftStore") }
}
