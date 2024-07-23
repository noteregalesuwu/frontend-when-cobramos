import { HttpClient } from '@angular/common/http';
import { Component, OnInit } from '@angular/core';
import { environment } from '../../../../environments/environment.development';
import { Observable } from 'rxjs';
import { MatChipSet, MatChipsModule } from '@angular/material/chips';
import { MatCardModule } from '@angular/material/card';

@Component({
  selector: 'app-visitor-count',
  standalone: true,
  imports: [MatChipsModule, MatChipSet, MatCardModule],
  templateUrl: './visitor-count.component.html',
  styleUrl: './visitor-count.component.css',
})
export class VisitorCountComponent implements OnInit {
  constructor(private readonly httpClient: HttpClient) {}

  public visitorCount = 0;
  public API_URL = environment.API_URL;

  ngOnInit(): void {
    this.registerVisit().subscribe(() => {
      this.httpClient
        .get(`${this.API_URL}/visitors/total`)
        .subscribe((response: any) => {
          this.visitorCount = response.count;
        });
    });
  }

  public registerVisit(): Observable<any> {
    return this.httpClient.post(`${this.API_URL}/visitors/register`, {
      name: 'when-cobramos-frontend',
    });
  }
}
