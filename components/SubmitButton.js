"use client";
// A submit button that disables itself while the form is being saved.
// Optional "confirmMessage" shows a Yes/No popup first (used for delete).
import { useFormStatus } from "react-dom";

export default function SubmitButton({
  children,
  pendingText = "Saving...",
  confirmMessage,
  className = "",
  ...props
}) {
  const { pending } = useFormStatus();

  return (
    <button
      type="submit"
      disabled={pending}
      onClick={(e) => {
        if (confirmMessage && !window.confirm(confirmMessage)) e.preventDefault();
      }}
      className={`disabled:opacity-60 ${className}`}
      {...props}
    >
      {pending ? pendingText : children}
    </button>
  );
}
