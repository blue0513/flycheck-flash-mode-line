;;; flycheck-flash-mode-line --- flash mode-line when flycheck detects errors.

;; Copyright (C) 2018- blue0513

;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation; either version 2 of the License, or
;; (at your option) any later version.
;;
;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
;; GNU General Public License for more details.
;;
;; You should have received a copy of the GNU General Public License
;; along with this program; if not, write to the Free Software
;; Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA 02110-1301 USA

;; Author: blue0513
;; URL: https://github.com/blue0513/flycheck-flash-mode-line
;; Version: 0.0.1
;; Package-Requires: ((flycheck "0.15"))

;;; Commentary:

;; Add this code bellow, and enable minor mode.
;;
;;   (require 'flycheck-flash-mode-line)
;;   (flycheck-flash-mode-line t)
;;

;;; Code:

(require 'flycheck)

(defcustom ffml--mode-line-color "red"
  "Mode line color when flashing."
  :type 'string
  :group 'flycheck-flash-mode-line)

(defun ffm-flash-mode-line (status)
  "Read STATUS and flash mode line."
  (when (eq status 'finished)
    (if (flycheck-has-current-errors-p 'error)
	(flash-mode-line))))

(defun flash-mode-line ()
  "Flash mode line instantly."
  (let ((orig-fg (face-background 'mode-line)))
    (set-face-background 'mode-line ffml--mode-line-color)
    (run-with-idle-timer 0.1 nil
			 (lambda (fg)
			   (set-face-background 'mode-line fg))
			 orig-fg)))

;;;###autoload
(define-minor-mode flycheck-flash-mode-line
  "Global minor mode for flycheck-flash-mode-line"
  :init-value nil
  :global t
  :lighter " ffml"
  (if flycheck-flash-mode-line
      (add-hook 'flycheck-status-changed-functions #'ffm-flash-mode-line)
    (remove-hook 'flycheck-status-changed-functions #'ffm-flash-mode-line)))

(provide 'flycheck-flash-mode-line)

;;; flycheck-flash-mode-line.el ends here
