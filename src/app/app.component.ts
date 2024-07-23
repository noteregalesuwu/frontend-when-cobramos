import { Component } from '@angular/core';
import { RouterLink, RouterLinkActive, RouterOutlet } from '@angular/router';
import { MatToolbarModule } from '@angular/material/toolbar';
import { MatIconModule } from '@angular/material/icon';
import { MatButtonModule } from '@angular/material/button';
import { MatCardModule } from '@angular/material/card';
import { LoaderComponent } from './shared/components/loader/loader.component';
import { LoaderService } from './shared/loader.service';

@Component({
  selector: 'app-root',
  standalone: true,
  imports: [
    RouterOutlet,
    MatToolbarModule,
    MatIconModule,
    MatButtonModule,
    MatCardModule,
    RouterLink,
    RouterLinkActive,
    LoaderComponent,
  ],
  templateUrl: './app.component.html',
  styleUrl: './app.component.css',
})
export class AppComponent {
  title = 'when-cobramos-frontend';
  public isLoading = false;
  constructor(private readonly loaderService: LoaderService) {
    this.loaderService.isLoading.subscribe((isLoading) => {
      this.isLoading = isLoading;
    });
  }
}
