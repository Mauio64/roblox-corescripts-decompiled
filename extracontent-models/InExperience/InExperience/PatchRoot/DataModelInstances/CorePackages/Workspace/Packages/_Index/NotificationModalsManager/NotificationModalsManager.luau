local NotificationModalsManager = {
	["jest.config"] = nil,
	["jest.config"] = nil,
	["jest.config"] = script["jest.config"]
}
local ModalRenderController = require(script.ModalRenderController)
NotificationModalsManager.OpenModal = ModalRenderController.OpenModal
local ModalRenderController2 = require(script.ModalRenderController)
NotificationModalsManager.CloseModal = ModalRenderController2.CloseModal
NotificationModalsManager.SetUIBloxToast = require(script.SetUIBloxToast)
return NotificationModalsManager
