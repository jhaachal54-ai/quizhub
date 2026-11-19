"use client";
// Builds a CSV file in the browser and downloads it (opens in Excel).

function toCsvValue(value) {
  const text = value === null || value === undefined ? "" : String(value);
  // Wrap in quotes and double any quotes inside, so commas don't break columns
  return `"${text.replace(/"/g, '""')}"`;
}

export default function ExportCsvButton({ filename, headers, rows }) {
  function download() {
    const lines = [headers, ...rows].map((row) => row.map(toCsvValue).join(","));
    // "﻿" tells Excel the file is UTF-8 (so names with accents work)
    const blob = new Blob(["﻿" + lines.join("\r\n")], {
      type: "text/csv;charset=utf-8",
    });
    const url = URL.createObjectURL(blob);
    const link = document.createElement("a");
    link.href = url;
    link.download = filename;
    link.click();
    URL.revokeObjectURL(url);
  }

  return (
    <button
      onClick={download}
      disabled={rows.length === 0}
      className="rounded-lg border border-slate-300 bg-white px-4 py-2 text-sm font-medium hover:bg-slate-50 disabled:opacity-50"
    >
      ⬇ Download CSV
    </button>
  );
}
