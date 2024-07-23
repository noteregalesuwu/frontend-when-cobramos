import { Component, Inject } from '@angular/core';
import { MatButton } from '@angular/material/button';
import {
  MAT_DIALOG_DATA,
  MatDialogActions,
  MatDialogContent,
  MatDialogModule,
  MatDialogTitle,
} from '@angular/material/dialog';

@Component({
  selector: 'app-view-meme',
  standalone: true,
  imports: [
    MatDialogActions,
    MatDialogContent,
    MatDialogActions,
    MatButton,
    MatDialogTitle,
    MatDialogModule,
  ],
  template: `<h2 mat-dialog-title>{{ data.title }}</h2>
    <mat-dialog-content>
      <img [src]="data.url" alt="Meme" class="meme-image" />
    </mat-dialog-content>
    <mat-dialog-actions>
      <button mat-button mat-dialog-close>Cerrar</button>
    </mat-dialog-actions>`,
  styles: [
    `
      :host {
        display: flex;
        flex-direction: column;
        height: 100%;
      }
      mat-dialog-content {
        max-height: unset !important;
        flex: 1 0 0;
        display: flex;
        justify-content: center;
        background-color: #000;
      }

      .meme-image {
        max-width: 100%;
        max-height: 100%;
        object-fit: contain;
      }
    `,
  ],
})
export class ViewMemeComponent {
  constructor(
    @Inject(MAT_DIALOG_DATA) public data: { title: string; url: string }
  ) {}
}
