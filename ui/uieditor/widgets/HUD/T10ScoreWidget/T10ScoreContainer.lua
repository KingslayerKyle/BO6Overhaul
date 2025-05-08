require( "ui.uieditor.widgets.HUD.T10ScoreWidget.T10ClientScore" )
require( "ui.uieditor.widgets.HUD.T10ScoreWidget.T10SelfScore" )

DataSources.ZMPlayerList = {
	getModel = function ( controller )
		return Engine.CreateModel( Engine.GetModelForController( controller ), "PlayerList" )
	end
}

local SetT10Models = function ( self, controller )
	local controllerModel = Engine.GetModelForController( controller )

	local junkModel = Engine.CreateModel( controllerModel, "t10_junk" )
	Engine.SetModelValue( junkModel, 0 )

	for index = 0, Dvar.com_maxclients:get() - 1 do
		local healthModel = Engine.CreateModel( controllerModel, "t10_health_" .. index )
		local armorTierModel = Engine.CreateModel( controllerModel, "t10_armor_vest_tier_" .. index )
		local armorPlateModel = Engine.CreateModel( controllerModel, "t10_armor_vest_plate_" .. index )
		local armorHealthModel = Engine.CreateModel( controllerModel, "t10_armor_vest_health_" .. index )

		Engine.SetModelValue( healthModel, 1 )
		Engine.SetModelValue( armorTierModel, 0 )
		Engine.SetModelValue( armorPlateModel, 0 )
		Engine.SetModelValue( armorHealthModel, 0 )
	end
end

local PreLoadFunc = function ( self, controller )
	SetT10Models( self, controller )
end

local PostLoadFunc = function ( self, controller )
	self:subscribeToModel( Engine.GetModel( Engine.GetGlobalModel(), "fastRestart" ), function ( model )
		SetT10Models( self, controller )
	end )
end

CoD.T10ScoreContainer = InheritFrom( LUI.UIElement )
CoD.T10ScoreContainer.new = function ( menu, controller )
	local self = LUI.UIElement.new()

	if PreLoadFunc then
		PreLoadFunc( self, controller )
	end

	self:setUseStencil( false )
	self:setClass( CoD.T10ScoreContainer )
	self.id = "T10ScoreContainer"
	self.soundSet = "default"
	self:setLeftRight( true, false, 0, 1280 )
	self:setTopBottom( true, false, 0, 720 )
	self.anyChildUsesUpdateState = true
	
	self.ListingUser = LUI.UIList.new( menu, controller, 2, 0, nil, false, false, 0, 0, false, false )
	self.ListingUser:makeFocusable()
	self.ListingUser:setLeftRight( true, true, 0, 0 )
	self.ListingUser:setTopBottom( true, true, 0, 0 )
	self.ListingUser:setWidgetType( CoD.T10SelfScore )
	self.ListingUser:setDataSource( "PlayerListZM" )
	self:addElement( self.ListingUser )
	
	self.Listing2 = CoD.T10ClientScore.new( menu, controller )
	self.Listing2:setLeftRight( true, true, 0, 0 )
	self.Listing2:setTopBottom( true, true, 0, 0 )
	self.Listing2:subscribeToGlobalModel( controller, "ZMPlayerList", "1", function ( model )
		self.Listing2:setModel( model, controller )
	end )
	self:addElement( self.Listing2 )
	
	self.Listing3 = CoD.T10ClientScore.new( menu, controller )
	self.Listing3:setLeftRight( true, true, 0, 0 )
	self.Listing3:setTopBottom( true, true, 0, -34.5 )
	self.Listing3:subscribeToGlobalModel( controller, "ZMPlayerList", "2", function ( model )
		self.Listing3:setModel( model, controller )
	end )
	self:addElement( self.Listing3 )
	
	self.Listing4 = CoD.T10ClientScore.new( menu, controller )
	self.Listing4:setLeftRight( true, true, 0, 0 )
	self.Listing4:setTopBottom( true, true, 0, -69 )
	self.Listing4:subscribeToGlobalModel( controller, "ZMPlayerList", "3", function ( model )
		self.Listing4:setModel( model, controller )
	end )
	self:addElement( self.Listing4 )

	self.clipsPerState = {
		DefaultState = {
			DefaultClip = function ()
				self:setupElementClipCounter( 4 )

				self.ListingUser:completeAnimation()
				self.ListingUser:setAlpha( 0 )
				self.clipFinished( self.ListingUser, {} )

				self.Listing2:completeAnimation()
				self.Listing2:setAlpha( 0 )
				self.clipFinished( self.Listing2, {} )

				self.Listing3:completeAnimation()
				self.Listing3:setAlpha( 0 )
				self.clipFinished( self.Listing3, {} )

				self.Listing4:completeAnimation()
				self.Listing4:setAlpha( 0 )
				self.clipFinished( self.Listing4, {} )
			end,
			HudStart = function ()
				self:setupElementClipCounter( 4 )

				local HudStartTransition = function ( element, event )
					if not event.interrupted then
						element:beginAnimation( "keyframe", 300, false, false, CoD.TweenType.Linear )
					end
	
					element:setAlpha( 1 )
	
					if event.interrupted then
						self.clipFinished( element, event )
					else
						element:registerEventHandler( "transition_complete_keyframe", self.clipFinished )
					end
				end

				self.ListingUser:completeAnimation()
				self.ListingUser:setAlpha( 0 )
				HudStartTransition( self.ListingUser, {} )

				self.Listing2:completeAnimation()
				self.Listing2:setAlpha( 0 )
				HudStartTransition( self.Listing2, {} )

				self.Listing3:completeAnimation()
				self.Listing3:setAlpha( 0 )
				HudStartTransition( self.Listing3, {} )

				self.Listing4:completeAnimation()
				self.Listing4:setAlpha( 0 )
				HudStartTransition( self.Listing4, {} )
			end
		},
		HudStart = {
			DefaultClip = function ()
				self:setupElementClipCounter( 4 )

				self.ListingUser:completeAnimation()
				self.ListingUser:setAlpha( 1 )
				self.clipFinished( self.ListingUser, {} )

				self.Listing2:completeAnimation()
				self.Listing2:setAlpha( 1 )
				self.clipFinished( self.Listing2, {} )

				self.Listing3:completeAnimation()
				self.Listing3:setAlpha( 1 )
				self.clipFinished( self.Listing3, {} )

				self.Listing4:completeAnimation()
				self.Listing4:setAlpha( 1 )
				self.clipFinished( self.Listing4, {} )
			end,
			DefaultState = function ()
				self:setupElementClipCounter( 4 )
				
				local DefaultStateTransition = function ( element, event )
					if not event.interrupted then
						element:beginAnimation( "keyframe", 300, false, false, CoD.TweenType.Linear )
					end
	
					element:setAlpha( 0 )
	
					if event.interrupted then
						self.clipFinished( element, event )
					else
						element:registerEventHandler( "transition_complete_keyframe", self.clipFinished )
					end
				end

				self.ListingUser:completeAnimation()
				self.ListingUser:setAlpha( 1 )
				DefaultStateTransition( self.ListingUser, {} )

				self.Listing2:completeAnimation()
				self.Listing2:setAlpha( 1 )
				DefaultStateTransition( self.Listing2, {} )

				self.Listing3:completeAnimation()
				self.Listing3:setAlpha( 1 )
				DefaultStateTransition( self.Listing3, {} )

				self.Listing4:completeAnimation()
				self.Listing4:setAlpha( 1 )
				DefaultStateTransition( self.Listing4, {} )
			end
		}
	}

	self:mergeStateConditions( {
		{
			stateName = "HudStart",
			condition = function ( menu, element, event )
				if IsModelValueTrue( controller, "hudItems.playerSpawned" ) then
					if Engine.IsVisibilityBitSet( controller, Enum.UIVisibilityBit.BIT_HUD_VISIBLE )
					and Engine.IsVisibilityBitSet( controller, Enum.UIVisibilityBit.BIT_WEAPON_HUD_VISIBLE )
					and not Engine.IsVisibilityBitSet( controller, Enum.UIVisibilityBit.BIT_HUD_HARDCORE )
					and not Engine.IsVisibilityBitSet( controller, Enum.UIVisibilityBit.BIT_GAME_ENDED )
					and not Engine.IsVisibilityBitSet( controller, Enum.UIVisibilityBit.BIT_DEMO_CAMERA_MODE_MOVIECAM )
					and not Engine.IsVisibilityBitSet( controller, Enum.UIVisibilityBit.BIT_DEMO_ALL_GAME_HUD_HIDDEN )
					and not Engine.IsVisibilityBitSet( controller, Enum.UIVisibilityBit.BIT_IN_KILLCAM )
					and not Engine.IsVisibilityBitSet( controller, Enum.UIVisibilityBit.BIT_IS_FLASH_BANGED )
					and not Engine.IsVisibilityBitSet( controller, Enum.UIVisibilityBit.BIT_UI_ACTIVE )
					and not Engine.IsVisibilityBitSet( controller, Enum.UIVisibilityBit.BIT_IS_SCOPED )
					and not Engine.IsVisibilityBitSet( controller, Enum.UIVisibilityBit.BIT_IN_VEHICLE )
					and not Engine.IsVisibilityBitSet( controller, Enum.UIVisibilityBit.BIT_IN_GUIDED_MISSILE )
					and not Engine.IsVisibilityBitSet( controller, Enum.UIVisibilityBit.BIT_SCOREBOARD_OPEN )
					and not Engine.IsVisibilityBitSet( controller, Enum.UIVisibilityBit.BIT_IN_REMOTE_KILLSTREAK_STATIC )
					and not Engine.IsVisibilityBitSet( controller, Enum.UIVisibilityBit.BIT_EMP_ACTIVE ) then
						return true
					else
						return false
					end
				end
			end
		}
	} )
	self:subscribeToModel( Engine.GetModel( Engine.GetModelForController( controller ), "hudItems.playerSpawned" ), function ( model )
		menu:updateElementState( self, {
			name = "model_validation",
			menu = self,
			modelValue = Engine.GetModelValue( model ),
			modelName = "hudItems.playerSpawned"
		} )
	end )
	self:subscribeToModel( Engine.GetModel( Engine.GetModelForController( controller ), "UIVisibilityBit." .. Enum.UIVisibilityBit.BIT_HUD_VISIBLE ), function ( model )
		menu:updateElementState( self, {
			name = "model_validation",
			menu = self,
			modelValue = Engine.GetModelValue( model ),
			modelName = "UIVisibilityBit." .. Enum.UIVisibilityBit.BIT_HUD_VISIBLE
		} )
	end )
	self:subscribeToModel( Engine.GetModel( Engine.GetModelForController( controller ), "UIVisibilityBit." .. Enum.UIVisibilityBit.BIT_WEAPON_HUD_VISIBLE ), function ( model )
		menu:updateElementState( self, {
			name = "model_validation",
			menu = self,
			modelValue = Engine.GetModelValue( model ),
			modelName = "UIVisibilityBit." .. Enum.UIVisibilityBit.BIT_WEAPON_HUD_VISIBLE
		} )
	end )
	self:subscribeToModel( Engine.GetModel( Engine.GetModelForController( controller ), "UIVisibilityBit." .. Enum.UIVisibilityBit.BIT_HUD_HARDCORE ), function ( model )
		menu:updateElementState( self, {
			name = "model_validation",
			menu = self,
			modelValue = Engine.GetModelValue( model ),
			modelName = "UIVisibilityBit." .. Enum.UIVisibilityBit.BIT_HUD_HARDCORE
		} )
	end )
	self:subscribeToModel( Engine.GetModel( Engine.GetModelForController( controller ), "UIVisibilityBit." .. Enum.UIVisibilityBit.BIT_GAME_ENDED ), function ( model )
		menu:updateElementState( self, {
			name = "model_validation",
			menu = self,
			modelValue = Engine.GetModelValue( model ),
			modelName = "UIVisibilityBit." .. Enum.UIVisibilityBit.BIT_GAME_ENDED
		} )
	end )
	self:subscribeToModel( Engine.GetModel( Engine.GetModelForController( controller ), "UIVisibilityBit." .. Enum.UIVisibilityBit.BIT_DEMO_CAMERA_MODE_MOVIECAM ), function ( model )
		menu:updateElementState( self, {
			name = "model_validation",
			menu = self,
			modelValue = Engine.GetModelValue( model ),
			modelName = "UIVisibilityBit." .. Enum.UIVisibilityBit.BIT_DEMO_CAMERA_MODE_MOVIECAM
		} )
	end )
	self:subscribeToModel( Engine.GetModel( Engine.GetModelForController( controller ), "UIVisibilityBit." .. Enum.UIVisibilityBit.BIT_DEMO_ALL_GAME_HUD_HIDDEN ), function ( model )
		menu:updateElementState( self, {
			name = "model_validation",
			menu = self,
			modelValue = Engine.GetModelValue( model ),
			modelName = "UIVisibilityBit." .. Enum.UIVisibilityBit.BIT_DEMO_ALL_GAME_HUD_HIDDEN
		} )
	end )
	self:subscribeToModel( Engine.GetModel( Engine.GetModelForController( controller ), "UIVisibilityBit." .. Enum.UIVisibilityBit.BIT_IN_KILLCAM ), function ( model )
		menu:updateElementState( self, {
			name = "model_validation",
			menu = self,
			modelValue = Engine.GetModelValue( model ),
			modelName = "UIVisibilityBit." .. Enum.UIVisibilityBit.BIT_IN_KILLCAM
		} )
	end )
	self:subscribeToModel( Engine.GetModel( Engine.GetModelForController( controller ), "UIVisibilityBit." .. Enum.UIVisibilityBit.BIT_IS_FLASH_BANGED ), function ( model )
		menu:updateElementState( self, {
			name = "model_validation",
			menu = self,
			modelValue = Engine.GetModelValue( model ),
			modelName = "UIVisibilityBit." .. Enum.UIVisibilityBit.BIT_IS_FLASH_BANGED
		} )
	end )
	self:subscribeToModel( Engine.GetModel( Engine.GetModelForController( controller ), "UIVisibilityBit." .. Enum.UIVisibilityBit.BIT_UI_ACTIVE ), function ( model )
		menu:updateElementState( self, {
			name = "model_validation",
			menu = self,
			modelValue = Engine.GetModelValue( model ),
			modelName = "UIVisibilityBit." .. Enum.UIVisibilityBit.BIT_UI_ACTIVE
		} )
	end )
	self:subscribeToModel( Engine.GetModel( Engine.GetModelForController( controller ), "UIVisibilityBit." .. Enum.UIVisibilityBit.BIT_IS_SCOPED ), function ( model )
		menu:updateElementState( self, {
			name = "model_validation",
			menu = self,
			modelValue = Engine.GetModelValue( model ),
			modelName = "UIVisibilityBit." .. Enum.UIVisibilityBit.BIT_IS_SCOPED
		} )
	end )
	self:subscribeToModel( Engine.GetModel( Engine.GetModelForController( controller ), "UIVisibilityBit." .. Enum.UIVisibilityBit.BIT_IN_VEHICLE ), function ( model )
		menu:updateElementState( self, {
			name = "model_validation",
			menu = self,
			modelValue = Engine.GetModelValue( model ),
			modelName = "UIVisibilityBit." .. Enum.UIVisibilityBit.BIT_IN_VEHICLE
		} )
	end )
	self:subscribeToModel( Engine.GetModel( Engine.GetModelForController( controller ), "UIVisibilityBit." .. Enum.UIVisibilityBit.BIT_IN_GUIDED_MISSILE ), function ( model )
		menu:updateElementState( self, {
			name = "model_validation",
			menu = self,
			modelValue = Engine.GetModelValue( model ),
			modelName = "UIVisibilityBit." .. Enum.UIVisibilityBit.BIT_IN_GUIDED_MISSILE
		} )
	end )
	self:subscribeToModel( Engine.GetModel( Engine.GetModelForController( controller ), "UIVisibilityBit." .. Enum.UIVisibilityBit.BIT_SCOREBOARD_OPEN ), function ( model )
		menu:updateElementState( self, {
			name = "model_validation",
			menu = self,
			modelValue = Engine.GetModelValue( model ),
			modelName = "UIVisibilityBit." .. Enum.UIVisibilityBit.BIT_SCOREBOARD_OPEN
		} )
	end )
	self:subscribeToModel( Engine.GetModel( Engine.GetModelForController( controller ), "UIVisibilityBit." .. Enum.UIVisibilityBit.BIT_IN_REMOTE_KILLSTREAK_STATIC ), function ( model )
		menu:updateElementState( self, {
			name = "model_validation",
			menu = self,
			modelValue = Engine.GetModelValue( model ),
			modelName = "UIVisibilityBit." .. Enum.UIVisibilityBit.BIT_IN_REMOTE_KILLSTREAK_STATIC
		} )
	end )
	self:subscribeToModel( Engine.GetModel( Engine.GetModelForController( controller ), "UIVisibilityBit." .. Enum.UIVisibilityBit.BIT_EMP_ACTIVE ), function ( model )
		menu:updateElementState( self, {
			name = "model_validation",
			menu = self,
			modelValue = Engine.GetModelValue( model ),
			modelName = "UIVisibilityBit." .. Enum.UIVisibilityBit.BIT_EMP_ACTIVE
		} )
	end )

	self.ListingUser.id = "ListingUser"

	LUI.OverrideFunction_CallOriginalSecond( self, "close", function ( element )
		element.ListingUser:close()
		element.Listing2:close()
		element.Listing3:close()
		element.Listing4:close()
	end )
	
	if PostLoadFunc then
		PostLoadFunc( self, controller, menu )
	end
	
	return self
end
