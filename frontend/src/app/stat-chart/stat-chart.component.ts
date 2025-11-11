import { Component, Input, OnChanges } from '@angular/core';
import { Chart, registerables } from 'chart.js';
Chart.register(...registerables);

@Component({
  selector: 'app-stat-chart',
  standalone: true,
  templateUrl: './stat-chart.component.html'
})
export class StatChartComponent implements OnChanges {
  @Input() data: any[] = [];
  chart: any;

  ngOnChanges() {
    if (this.chart) this.chart.destroy();
    const ctx = (document.getElementById('growthChart') as HTMLCanvasElement)?.getContext('2d');
    if (!ctx) return;

    this.chart = new Chart(ctx, {
      type: 'line',
      data: {
        labels: this.data.map(d => d.date),
        datasets: [{
          label: 'Followers',
          data: this.data.map(d => d.followers),
          borderColor: 'rgba(59,130,246,1)',
          backgroundColor: 'rgba(59,130,246,0.2)',
          fill: true,
          tension: 0.3
        }]
      },
      options: { responsive: true }
    });
  }
}
