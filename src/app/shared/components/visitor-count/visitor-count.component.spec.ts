import { ComponentFixture, TestBed } from '@angular/core/testing';

import { VisitorCountComponent } from './visitor-count.component';

describe('VisitorCountComponent', () => {
  let component: VisitorCountComponent;
  let fixture: ComponentFixture<VisitorCountComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      imports: [VisitorCountComponent]
    })
    .compileComponents();

    fixture = TestBed.createComponent(VisitorCountComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
