import { Component } from '@angular/core';
import { MatProgressSpinner } from '@angular/material/progress-spinner';

@Component({
  selector: 'app-loader',
  standalone: true,
  imports: [MatProgressSpinner],
  template: `
    <div class="loader-container">
      <mat-spinner></mat-spinner>
    </div>
  `,
  styles: [
    `
      .loader-container {
        position: fixed;
        top: 0;
        left: 0;
        width: 100vw;
        height: 100vh;
        display: flex;
        align-items: center;
        justify-content: center;
        background-color: rgba(0, 0, 0, 0.5);
        z-index: 1000;
      }
    `,
  ],
})
export class LoaderComponent {}
