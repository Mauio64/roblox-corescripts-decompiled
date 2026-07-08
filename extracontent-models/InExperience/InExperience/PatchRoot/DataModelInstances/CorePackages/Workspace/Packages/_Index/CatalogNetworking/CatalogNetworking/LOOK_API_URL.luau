local ParentParent = script.Parent.Parent

return require(ParentParent.SocialCommon).Utils.buildApiSiteUrl("apis") .. "/look-api/v1/looks/purchase-details"
