require( "ui.uieditor.widgets.HUD.T10AmmoWidget.T10AmmoEquipment" )
require( "ui.uieditor.widgets.HUD.T10AmmoWidget.T10AmmoInfo" )
require( "ui.uieditor.widgets.HUD.ZM_AmmoWidget.ZmAmmo_BBGumMeterWidget" )

local SetWeaponName = function ( controller, element )
	local weaponNameModel = Engine.GetModel( Engine.GetModelForController( controller ), "currentWeapon.weaponName" )
	local muleKickModel = Engine.GetModel( Engine.GetModelForController( controller ), "t10_mule_kick" )
	local weaponName = Engine.GetModelValue( weaponNameModel )
	local muleKick = Engine.GetModelValue( muleKickModel )

	if weaponName ~= nil and muleKick ~= nil then
		if muleKick == 1 then
			element:setText( Engine.Localize( weaponName .. " (MK)" ) )
		else
			element:setText( Engine.Localize( weaponName ) )
		end
	end
end

local PostLoadFunc = function ( self, controller, menu )
	LUI.OverrideFunction_CallOriginalFirst( self.AmmoInfo.AmmoClip, "setText", function ( element )
		local length = #tostring( self.AmmoInfo.AmmoClip:getText() )
		local ammoInDWClipModel = Engine.GetModel( Engine.GetModelForController( controller ), "currentWeapon.ammoInDWClip" )
		local ammoInDWClip = Engine.GetModelValue( ammoInDWClipModel )

		if length ~= nil and type( length ) == "number" and ammoInDWClip ~= nil then
			if ammoInDWClip ~= -1 then
				length = length - 5
			else
				length = length - 3
			end

			-- Width of the characters
			local shift = (length * 22)

			self.PAPImage:setLeftRight( false, true, -251.5 - shift, -235 - shift )
			self.AATImage:setLeftRight( false, true, -271.5 - shift, -255 - shift )
		end
	end )
end

CoD.T10AmmoContainer = InheritFrom( LUI.UIElement )
CoD.T10AmmoContainer.new = function ( menu, controller )
	local self = LUI.UIElement.new()

	if PreLoadFunc then
		PreLoadFunc( self, controller )
	end

	self:setUseStencil( false )
	self:setClass( CoD.T10AmmoContainer )
	self.id = "T10AmmoContainer"
	self.soundSet = "default"
	self:setLeftRight( true, false, 0, 1280 )
	self:setTopBottom( true, false, 0, 720 )
	self.anyChildUsesUpdateState = true

	self.ZmAmmoBBGumMeterWidget = CoD.ZmAmmo_BBGumMeterWidget.new( menu, controller )
	self.ZmAmmoBBGumMeterWidget:setLeftRight( true, false, 1207, 0 )
	self.ZmAmmoBBGumMeterWidget:setTopBottom( true, false, 554 - 75, 0 )
	self:addElement( self.ZmAmmoBBGumMeterWidget )

	self.AmmoBG1 = LUI.UIImage.new()
	self.AmmoBG1:setLeftRight( false, true, -318, -151 )
	self.AmmoBG1:setTopBottom( false, true, -63, -25.5 )
	self.AmmoBG1:setImage( RegisterImage( "ximage_69c2bf3c1b482b9" ) )
	self.AmmoBG1:setRGB( 0.3, 0.3, 0.3 )
	self.AmmoBG1:subscribeToModel( Engine.GetModel( Engine.GetModelForController( controller ), "t10_weapon_upgrade_tier" ), function ( model )
		local tier = Engine.GetModelValue( model )
		local r, g, b = 0.3, 0.3, 0.3
		
		if tier ~= nil and type( tier ) == "number" then
			tier = tier + 1

			if CoD.ZMWeaponRarities ~= nil then
				if CoD.ZMWeaponRarities[tier] ~= nil then
					r, g, b = CoD.ZMWeaponRarities[tier].r, CoD.ZMWeaponRarities[tier].g, CoD.ZMWeaponRarities[tier].b
				end
			end
		end

		self.AmmoBG1:setRGB( r, g, b )
	end )
	self:addElement( self.AmmoBG1 )

	self.AmmoBG2 = LUI.UIImage.new()
	self.AmmoBG2:setLeftRight( false, true, -318, -151 )
	self.AmmoBG2:setTopBottom( false, true, -63, -25.5 )
	self.AmmoBG2:setImage( RegisterImage( "ximage_df73a47b7b0ecca" ) )
	self.AmmoBG2:setAlpha( 0.7 )
	self:addElement( self.AmmoBG2 )

	self.StockBG = LUI.UIImage.new()
	self.StockBG:setLeftRight( false, true, -318, -151 )
	self.StockBG:setTopBottom( false, true, -63, -25.5 )
	self.StockBG:setImage( RegisterImage( "ximage_9b1b03086b597f" ) )
	self.StockBG:setAlpha( 0.3 )
	self:addElement( self.StockBG )

	self.AmmoEquipment = CoD.T10AmmoEquipment.new( menu, controller )
	self.AmmoEquipment:setLeftRight( true, true, 0, 0 )
	self.AmmoEquipment:setTopBottom( true, true, 0, 0 )
	self:addElement( self.AmmoEquipment )

	self.AmmoInfo = CoD.T10AmmoInfo.new( menu, controller )
	self.AmmoInfo:setLeftRight( true, true, 0, 0 )
	self.AmmoInfo:setTopBottom( true, true, 0, 0 )
	self:addElement( self.AmmoInfo )

	self.WeaponName = LUI.UIText.new()
	self.WeaponName:setLeftRight( true, true, 0, 213 )
	self.WeaponName:setTopBottom( false, true, -58 - 29, -25 - 29 )
	self.WeaponName:setAlignment( Enum.LUIAlignment.LUI_ALIGNMENT_RIGHT )
	self.WeaponName:setTTF( "fonts/kairos_sans_w1g_cn.ttf" )
	self.WeaponName:setScale( 0.5 )
	self.WeaponName:subscribeToModel( Engine.GetModel( Engine.GetModelForController( controller ), "currentWeapon.weaponName" ), function ( model )
		SetWeaponName( controller, self.WeaponName )
	end )
	self.WeaponName:subscribeToModel( Engine.GetModel( Engine.GetModelForController( controller ), "t10_mule_kick" ), function ( model )
		SetWeaponName( controller, self.WeaponName )
	end )
	self:addElement( self.WeaponName )

	self.PAPImage = LUI.UIImage.new()
    self.PAPImage:setLeftRight( false, true, -251.5, -235 )
    self.PAPImage:setTopBottom( false, true, -56, -40 )
	self.PAPImage:setImage( RegisterImage( "blacktransparent" ) )
	self.PAPImage:subscribeToModel( Engine.GetModel( Engine.GetModelForController( controller ), "t10_pack_a_punch_tier" ), function ( model )
		local tier = Engine.GetModelValue( model )
		
		if tier then
			if tier > 0 then
				self.PAPImage:setImage( RegisterImage( "jup_ui_icons_pap_level" .. tostring( tier ) ) )
			else
				self.PAPImage:setImage( RegisterImage( "blacktransparent" ) )
			end
		end
	end )
	self:addElement( self.PAPImage )

	self.AATImage = LUI.UIImage.new()
    self.AATImage:setLeftRight( false, true, -271.5, -255 )
    self.AATImage:setTopBottom( false, true, -56, -40 )
	self.AATImage:setImage( RegisterImage( "blacktransparent" ) )
	self.AATImage:subscribeToModel( Engine.GetModel( Engine.GetModelForController( controller ), "currentWeapon.aatIcon" ), function ( model )
		local aatIcon = Engine.GetModelValue( model )

		if aatIcon then
			if aatIcon == "t7_icon_zm_aat_dead_wire" then
				aatIcon = "ui_icons_elementaldamage_electrical"

			elseif aatIcon == "t7_icon_zm_aat_blast_furnace" then
				aatIcon = "ui_icons_elementaldamage_fire"

			elseif aatIcon == "t7_icon_zm_aat_fire_works" then
				aatIcon = "ui_icons_elementaldamage_pyro"

			elseif aatIcon == "t7_icon_zm_aat_turned" then
				aatIcon = "ui_icons_elementaldamage_toxic"

			elseif aatIcon == "t7_icon_zm_aat_thunder_wall" then
				aatIcon = "ui_icons_elementaldamage_storm"

			else
				aatIcon = "blacktransparent"
			end

			self.AATImage:setImage( RegisterImage( aatIcon ) )
		end
	end )
	self:addElement( self.AATImage )

	self.clipsPerState = {
		DefaultState = {
			DefaultClip = function ()
				self:setupElementClipCounter( 9 )

				self.ZmAmmoBBGumMeterWidget:completeAnimation()
				self.ZmAmmoBBGumMeterWidget:setAlpha( 0 )
				self.clipFinished( self.ZmAmmoBBGumMeterWidget, {} )

				self.AmmoBG1:completeAnimation()
				self.AmmoBG1:setAlpha( 0 )
				self.clipFinished( self.AmmoBG1, {} )

				self.AmmoBG2:completeAnimation()
				self.AmmoBG2:setAlpha( 0 )
				self.clipFinished( self.AmmoBG2, {} )

				self.StockBG:completeAnimation()
				self.StockBG:setAlpha( 0 )
				self.clipFinished( self.StockBG, {} )

				self.AmmoEquipment:completeAnimation()
				self.AmmoEquipment:setAlpha( 0 )
				self.clipFinished( self.AmmoEquipment, {} )

				self.AmmoInfo:completeAnimation()
				self.AmmoInfo:setAlpha( 0 )
				self.clipFinished( self.AmmoInfo, {} )

				self.WeaponName:completeAnimation()
				self.WeaponName:setAlpha( 0 )
				self.clipFinished( self.WeaponName, {} )

				self.PAPImage:completeAnimation()
				self.PAPImage:setAlpha( 0 )
				self.clipFinished( self.PAPImage, {} )

				self.AATImage:completeAnimation()
				self.AATImage:setAlpha( 0 )
				self.clipFinished( self.AATImage, {} )
			end,
			HudStart = function ()
				self:setupElementClipCounter( 9 )

				local HudStartTransition = function ( element, alpha, event )
					if not event.interrupted then
						element:beginAnimation( "keyframe", 300, false, false, CoD.TweenType.Linear )
					end
	
					element:setAlpha( alpha )
	
					if event.interrupted then
						self.clipFinished( element, event )
					else
						element:registerEventHandler( "transition_complete_keyframe", self.clipFinished )
					end
				end

				self.ZmAmmoBBGumMeterWidget:completeAnimation()
				self.ZmAmmoBBGumMeterWidget:setAlpha( 0 )
				HudStartTransition( self.ZmAmmoBBGumMeterWidget, 1, {} )

				self.AmmoBG1:completeAnimation()
				self.AmmoBG1:setAlpha( 0 )
				HudStartTransition( self.AmmoBG1, 1, {} )

				self.AmmoBG2:completeAnimation()
				self.AmmoBG2:setAlpha( 0 )
				HudStartTransition( self.AmmoBG2, 0.7, {} )

				self.StockBG:completeAnimation()
				self.StockBG:setAlpha( 0 )
				HudStartTransition( self.StockBG, 0.3, {} )

				self.AmmoEquipment:completeAnimation()
				self.AmmoEquipment:setAlpha( 0 )
				HudStartTransition( self.AmmoEquipment, 1, {} )

				self.AmmoInfo:completeAnimation()
				self.AmmoInfo:setAlpha( 0 )
				HudStartTransition( self.AmmoInfo, 1, {} )

				self.WeaponName:completeAnimation()
				self.WeaponName:setAlpha( 0 )
				HudStartTransition( self.WeaponName, 1, {} )

				self.PAPImage:completeAnimation()
				self.PAPImage:setAlpha( 0 )
				HudStartTransition( self.PAPImage, 1, {} )

				self.AATImage:completeAnimation()
				self.AATImage:setAlpha( 0 )
				HudStartTransition( self.AATImage, 1, {} )
			end
		},
		HudStart = {
			DefaultClip = function ()
				self:setupElementClipCounter( 9 )

				self.ZmAmmoBBGumMeterWidget:completeAnimation()
				self.ZmAmmoBBGumMeterWidget:setAlpha( 1 )
				self.clipFinished( self.ZmAmmoBBGumMeterWidget, {} )

				self.AmmoBG1:completeAnimation()
				self.AmmoBG1:setAlpha( 1 )
				self.clipFinished( self.AmmoBG1, {} )

				self.AmmoBG2:completeAnimation()
				self.AmmoBG2:setAlpha( 0.7 )
				self.clipFinished( self.AmmoBG2, {} )

				self.StockBG:completeAnimation()
				self.StockBG:setAlpha( 0.3 )
				self.clipFinished( self.StockBG, {} )

				self.AmmoEquipment:completeAnimation()
				self.AmmoEquipment:setAlpha( 1 )
				self.clipFinished( self.AmmoEquipment, {} )

				self.AmmoInfo:completeAnimation()
				self.AmmoInfo:setAlpha( 1 )
				self.clipFinished( self.AmmoInfo, {} )

				self.WeaponName:completeAnimation()
				self.WeaponName:setAlpha( 1 )
				self.clipFinished( self.WeaponName, {} )

				self.PAPImage:completeAnimation()
				self.PAPImage:setAlpha( 1 )
				self.clipFinished( self.PAPImage, {} )

				self.AATImage:completeAnimation()
				self.AATImage:setAlpha( 1 )
				self.clipFinished( self.AATImage, {} )
			end,
			DefaultState = function ()
				self:setupElementClipCounter( 9 )
				
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

				self.ZmAmmoBBGumMeterWidget:completeAnimation()
				self.ZmAmmoBBGumMeterWidget:setAlpha( 1 )
				DefaultStateTransition( self.ZmAmmoBBGumMeterWidget, {} )

				self.AmmoBG1:completeAnimation()
				self.AmmoBG1:setAlpha( 1 )
				DefaultStateTransition( self.AmmoBG1, {} )

				self.AmmoBG2:completeAnimation()
				self.AmmoBG2:setAlpha( 0.7 )
				DefaultStateTransition( self.AmmoBG2, {} )

				self.StockBG:completeAnimation()
				self.StockBG:setAlpha( 0.3 )
				DefaultStateTransition( self.StockBG, {} )

				self.AmmoEquipment:completeAnimation()
				self.AmmoEquipment:setAlpha( 1 )
				DefaultStateTransition( self.AmmoEquipment, {} )

				self.AmmoInfo:completeAnimation()
				self.AmmoInfo:setAlpha( 1 )
				DefaultStateTransition( self.AmmoInfo, {} )

				self.WeaponName:completeAnimation()
				self.WeaponName:setAlpha( 1 )
				DefaultStateTransition( self.WeaponName, {} )

				self.PAPImage:completeAnimation()
				self.PAPImage:setAlpha( 1 )
				DefaultStateTransition( self.PAPImage, {} )

				self.AATImage:completeAnimation()
				self.AATImage:setAlpha( 1 )
				DefaultStateTransition( self.AATImage, {} )
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

	LUI.OverrideFunction_CallOriginalSecond( self, "close", function ( element )
		element.ZmAmmoBBGumMeterWidget:close()
		element.AmmoBG1:close()
		element.AmmoBG2:close()
		element.StockBG:close()
		element.AmmoEquipment:close()
		element.AmmoInfo:close()
		element.WeaponName:close()
		element.PAPImage:close()
		element.AATImage:close()
	end )
	
	if PostLoadFunc then
		PostLoadFunc( self, controller, menu )
	end
	
	return self
end
