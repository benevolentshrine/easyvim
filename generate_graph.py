
def create_bar_chart(filename="assets/resource_benchmark.svg"):
    # Data
    data = [
        ("Vim (Stock)", 9, "#888888"),
        ("Neovim (Stock)", 12, "#57A143"),
        ("EasyVim", 25, "#89e051"),
        ("VS Code (Idle)", 800, "#007ACC")
    ]
    
    max_val = 850
    width = 800
    height = 400
    bar_height = 50
    gap = 20
    start_y = 60
    label_width = 150
    chart_width = width - label_width - 50

    svg = []
    svg.append(f'<svg width="{width}" height="{height}" xmlns="http://www.w3.org/2000/svg">')
    
    # Background
    svg.append(f'<rect width="100%" height="100%" fill="white"/>')
    
    # Title
    svg.append(f'<text x="{width/2}" y="30" font-family="Arial, sans-serif" font-size="20" font-weight="bold" text-anchor="middle">RAM Consumption Benchmark (Idle)</text>')
    
    y = start_y
    for label, value, color in data:
        bar_w = (value / max_val) * chart_width
        
        # Label
        svg.append(f'<text x="{label_width - 10}" y="{y + bar_height/2 + 5}" font-family="Arial, sans-serif" font-size="14" text-anchor="end">{label}</text>')
        
        # Bar
        svg.append(f'<rect x="{label_width}" y="{y}" width="{bar_w}" height="{bar_height}" fill="{color}" rx="4" />')
        
        # Value Text
        text_x = label_width + bar_w + 10
        svg.append(f'<text x="{text_x}" y="{y + bar_height/2 + 5}" font-family="Arial, sans-serif" font-size="12" font-weight="bold">{value} MB</text>')
        
        y += bar_height + gap

    # Annotations
    svg.append(f'<line x1="{label_width + (25/max_val)*chart_width}" y1="{start_y}" x2="{label_width + (25/max_val)*chart_width}" y2="{height - 50}" stroke="green" stroke-dasharray="4" opacity="0.5" />')
    svg.append(f'<text x="{label_width + 20}" y="{height - 30}" font-family="Arial, sans-serif" font-size="12" fill="green">Runs on Cloud/Pi</text>')

    svg.append(f'<line x1="{label_width + (800/max_val)*chart_width}" y1="{start_y}" x2="{label_width + (800/max_val)*chart_width}" y2="{height - 50}" stroke="red" stroke-dasharray="4" opacity="0.5" />')
    
    svg.append('</svg>')
    
    with open(filename, "w") as f:
        f.write("\n".join(svg))
    print(f"SVG saved to {filename}")

if __name__ == "__main__":
    create_bar_chart()
