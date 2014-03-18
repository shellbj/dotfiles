import XMonad
import XMonad.Config.Desktop
import XMonad.Config.Xfce
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.ManageHelpers
import XMonad.Util.EZConfig

import qualified Data.Map as M

myManageHook = composeAll [
  className =? "Xfce4-notifyd" --> doIgnore, -- notifications will steal focus otherwise
  className =? "Wrapper" --> doFloat,
  className =? "MPlayer" --> doFloat,
  className =? "Gimp" --> doFloat,
  className =? "Xfce4-appfinder" --> doCenterFloat,
  className =? "Xfrun4" --> doCenterFloat,
  className =? "Do" --> doCenterFloat,
  className =? "Xfce4-notes" --> doCenterFloat,
  className =? "Xfce4-panel"    --> doFloat,
  className =? "Xfce-mcs-manager" --> doFloat,
  className =? "Xfce-mixer"	      --> doFloat,
  resource  =? "desktop_window" --> doIgnore,
  resource  =? "Xfdesktop" --> doIgnore
  ]


main = xmonad $ xfceConfig {
  manageHook = manageDocks <+> myManageHook
  , terminal = "xfce4-terminal"
  , modMask = mod4Mask
  , keys = \c -> myXfceKeys c `M.union` keys desktopConfig c
  }

myXfceKeys (XConfig {modMask = modm}) = M.fromList $ [
  ((modm .|. shiftMask, xK_p), spawn "xfrun4")
  , ((modm, xK_p), spawn "gnome-do")
  , ((modm .|. shiftMask, xK_q), spawn "xfce4-session-logout")
  ]

otherKeys = \c -> mkKeymap c $[
  ("<XF86ScreenSaver>", spawn "xscreensaver-command -lock")
  ]
