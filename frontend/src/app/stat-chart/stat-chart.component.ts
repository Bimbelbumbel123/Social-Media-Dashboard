import { Component, Input, OnInit, ElementRef, ViewChild, AfterViewInit } from '@angular/core';
import { CommonModule } from '@angular/common';
import { ChartData } from '../dashboard/dashboard.component';

declare var Chart: any;

@Component({
  selector: 'app-stat-chart',
  standalone: true,
  imports: [CommonModule],
  templateUrl: './stat-chart.component.html'
})
export class StatChartComponent implements AfterViewInit {
  @Input() data!: ChartData[];
  @ViewChild('chartCanvas', { static: false }) chartCanvas!: ElementRef<HTMLCanvasElement>;

  private chart: any;

  ngAfterViewInit() {
    this.createChart();
  }

  ngOnChanges() {
    if (this.chart) {
      this.updateChart();
    }
  }

  private createChart() {
    const ctx = this.chartCanvas.nativeElement.getContext('2d');

    this.chart = new Chart(ctx, {
      type: 'line',
      data: {
        labels: this.data.map(d => d.month),
        datasets: [
          {
            label: 'YouTube',
            data: this.data.map(d => d.YouTube),
            borderColor: '#FF0000',
            backgroundColor: 'rgba(255, 0, 0, 0.1)',
            tension: 0.4
          },
          {
            label: 'TikTok',
            data: this.data.map(d => d.TikTok),
            borderColor: '#5ddbe1',
            backgroundColor: 'rgba(238, 29, 82, 0.1)',
            tension: 0.4
          },
          {
            label: 'Instagram',
            data: this.data.map(d => d.Instagram),
            borderColor: '#f2adf6',
            backgroundColor: 'rgba(228, 64, 95, 0.1)',
            tension: 0.4
          },
          {
            label: 'Twitch',
            data: this.data.map(d => d.Twitch),
            borderColor: '#ce27f3',
            backgroundColor: 'rgba(145, 70, 255, 0.1)',
            tension: 0.4
          }
        ]
      },
      options: {
        responsive: true,
        maintainAspectRatio: true,
        aspectRatio: 2.5,
        plugins: {
          legend: {
            position: 'top',
          },
          tooltip: {
            mode: 'index',
            intersect: false,
          }
        },
        scales: {
          y: {
            beginAtZero: false,
            ticks: {
              callback: function(value: number) {
                return value.toLocaleString();
              }
            }
          }
        }
      }
    });
  }

  private updateChart() {
    this.chart.data.labels = this.data.map(d => d.month);
    this.chart.data.datasets[0].data = this.data.map(d => d.YouTube);
    this.chart.data.datasets[1].data = this.data.map(d => d.TikTok);
    this.chart.data.datasets[2].data = this.data.map(d => d.Instagram);
    this.chart.data.datasets[3].data = this.data.map(d => d.Twitch);
    this.chart.update();
  }

  ngOnDestroy() {
    if (this.chart) {
      this.chart.destroy();
    }
  }
}
