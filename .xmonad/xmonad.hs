import XMonad
import XMonad.Config.Xfce
import XMonad.Hooks.ManageHelpers

myManageHook = composeAll [
  className =? "Xfce4-notifyd" --> doIgnore -- notifications will steal focus otherwise
  , className =? "Xfce4-appfinder" --> doCenterFloat
  , className =? "Xfrun4" --> doCenterFloat
  -- , className =? "Wrapper" --> doFloat
  -- , className =? "MPlayer" --> doFloat
  -- , className =? "Gimp" --> doFloat
  -- , className =? "Do" --> doCenterFloat
  -- , className =? "Xfce4-notes" --> doCenterFloat
  -- , className =? "Xfce4-panel"    --> doFloat
  -- , className =? "Xfce-mcs-manager" --> doFloat
  -- , className =? "Xfce-mixer"	      --> doFloat
  -- , resource  =? "desktop_window" --> doIgnore
  -- , resource  =? "Xfdesktop" --> doIgnore
  ]

main = xmonad $ xfceConfig {
  manageHook = myManageHook <+> manageHook xfceConfig
  , terminal = "xfce4-terminal"
  , modMask = mod4Mask
  }
