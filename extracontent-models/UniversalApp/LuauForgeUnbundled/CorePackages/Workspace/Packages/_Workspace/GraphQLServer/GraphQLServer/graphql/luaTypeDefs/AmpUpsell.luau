return [[
	  enum Access {
	    Granted
	    Denied
	    Actionable
	    Pending
	    Error
	  }
	
	  enum RecourseActions {
	    Phone
	    Email
	    GovernmentId
	    AddedEmail
	    ParentConsent
	    ParentLink
	    AgeEstimation
	    Subscription
	    CardVerification
	    Wait
	    UserAgreement
	    UserSettings
	    Invalid
	  }
	
	  enum VPCRequestTypes {
	    ChargebackReenableAccount
	    SavePaymentMethods
	    UpdateUserSetting
	    UpdateBirthdate
	    LinkToChild
	    ManageFriend
	    ManageExperience
	    LiftPunishment
	    AddTrustedConnection
	    SendTransfer
	    ReceiveTransfer
	    LiftRestriction
	    Unknown
	  }
	
	  type TimeoutActionResponse {
	    featureVector: String
	    endTime: String
	    startTime: String
	    duration: Int
	    vectorTargetID: String
	    evidence: String
	    decisionEventID: String
	    violationType: Int
	    sublabel: Int
	    acknowledgedTime: String
	    permanent: Boolean
	    acknowledgeable: Boolean
	  }
	
	  type AgreementResponse {
	    id: String
	    displayUrl: String
	  }
	
	  type UserSettingsResponse {
	    settingName: String
	    settingValue: String
	  }
	
	  type RecourseResponses {
	    action: RecourseActions
	    parentConsentTypes: [ VPCRequestTypes ]
	    timeoutActions: [ TimeoutActionResponse ]
	    agreements: [ AgreementResponse ]
	    userSettings: UserSettingsResponse
	  }
	
	  type FeatureAccess {
	    featureName: String
	    access: Access
	    recourse: [ RecourseActions ]
	    recourses: [ RecourseResponses ]
	  }
	
	  type UpsellFeatureAccessResponse {
	    featureAccess: FeatureAccess
	    shouldPrompt: Boolean
	  }
	
	  type FeatureAccessResponse {
	    features: [FeatureAccess]
	  }
	
	  type Query {
	    # TODO: pass in optional response cache-control value after MVP
	    # On page mount, e.g. in ExperienceDetailsContainer
	    getFeatureAccess(featureNames: [String]): FeatureAccessResponse
	
	    # On demand, navigation to a 17+ game, e.g. We already have the successfulActions info.
	    getUpsellFeatureAccess(featureName: String, successfulActions: [RecourseActions], nameSpace: String, extraParameters: String): UpsellFeatureAccessResponse
	  }
	]]
