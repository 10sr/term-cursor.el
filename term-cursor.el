;;; term-cursor.el --- Change cursor shape in terminal

;; Version: 0.1
;; Author: h0d
;; URL: https://github.com/h0d
;; Keywords: terminal, cursor
;; Package-Requires: ((emacs "26.1"))

;;; Commentary:

;; Send escape codes to change cursor in terminal.

;;; Code:
(defun cursor-watcher (_symbol val op _watch)
  "Change cursor through escape sequences depending on VAL.
Waits for OP to be 'set."
  ;; Using VT520 DECSCUSR
  ;; from https://invisible-island.net/xterm/ctlseqs/ctlseqs.html
  (unless (display-graphic-p)
    (when (eq op 'set)
      (cond
       ;; Symbol ('box, 'hollow, 'bar, 'hbar)
       ((eq (type-of val) 'symbol)
	(cond ((eq val 'bar)
	       (send-string-to-terminal "\e[5 q"))
	      ((eq val 'hbar)
	       (send-string-to-terminal "\e[3 q"))
	      (t
	       (send-string-to-terminal "\e[1 q"))))
       ;; Cons ((bar . WIDTH), (hbar . HEIGHT))
       ((eq (type-of val) 'cons)
	(cond ((eq (car val) 'bar)
	       (send-string-to-terminal "\e[5 q"))
	      ((eq (car val) 'hbar)
	       (send-string-to-terminal "\e[3 q"))
	      (t
	       (send-string-to-terminal "\e[1 q"))))
       ;; Anything else
       (t
	(send-string-to-terminal "\e[1 q"))))))

;;;###autoload
(defun term-cursor-watch ()
  "Start watching cursor change."
  (interactive)
  (add-variable-watcher 'cursor-type #'cursor-watcher))

;;;###autoload
(defun term-cursor-unwatch ()
  "Start watching cursor change."
  (interactive)
  (remove-variable-watcher 'cursor-type #'cursor-watcher))

(provide 'term-cursor)

;;; term-cursor.el ends here